module BootstrapAdmin

  # This module defines default controller actions
  # * index
  # * show
  # * create
  # * update
  # * destroy
  # These actions are automagically injected on every controller
  # that declares the usage of bootstrap_admin
  module Actions

    # The actual controller action methods!
    module InstanceMethods

      # =============================================================================
      # Lists (all) items
      def index; namespaced_response collection; end

      # =============================================================================
      # Shows a specific item
      def show; namespaced_response instance; end

      # =============================================================================
      # Displays the form to create a new item
      def new; namespaced_response instance; end

      # =============================================================================
      # Creates a new item
      def create
        instance model_class.new(params[model_name])
        instance.save
        namespaced_response instance
      end

      # =============================================================================
      # Displays the form to edit an existing item
      def edit; namespaced_response instance; end

      # =============================================================================
      # Updates the existing item
      def update
        instance.update_attributes params[model_name]
        namespaced_response instance
      end

      # =============================================================================
      # Destroys an existing item
      def destroy
        instance.destroy
        namespaced_response instance
      end

      protected
        # =============================================================================
        # @return [String] model name based on the controller's name
        def model_name
          if bootstrap_admin_config.model_name.blank?
            collection_name.singularize
          else
            bootstrap_admin_config.model_name.underscore.gsub("/","_")
          end
        end

        # =============================================================================
        # @return [ActiveRecord::Base] model class based on the controller's name
        def model_class
          if bootstrap_admin_config.model_name.blank?
            collection_name.singularize.classify.constantize
          else
            bootstrap_admin_config.model_name.constantize
          end
        end

        # =============================================================================
        # @return [ActiveRecord::Base] instance
        def instance instance_var = nil
          if instance_var
            instance_variable_set "@#{collection_name.singularize}", instance_var
          else
            unless ivar = instance_variable_get("@#{collection_name.singularize}")
              ivar = if ["new", "create"].include? params[:action]
                model_class.new
              else
                model_class.find params[:id]
              end
              instance_variable_set "@#{collection_name.singularize}", ivar
            end
            ivar
          end
        end

        # =============================================================================
        # @return [ActiveRecord::Relation] collection of all items for the model
        # named after the controller
        def collection collection_var = nil
          if collection_var
            instance_variable_set "@#{collection_name}", collection_var
          else
            unless cvar = instance_variable_get("@#{collection_name}")
              cvar = model_class.scoped
              instance_variable_set "@#{collection_name}", cvar
            end
            cvar
          end
        end

        # =============================================================================
        # @return [String] collection name based on the controller name
        def collection_name
          self.class.name.sub("Controller", "").underscore.split('/').last
        end

      private
        # =============================================================================
        # Prepares a response using the controllers reponder.
        def namespaced_response var
          # namespace is a property of BootstrapAdmin::Config and gets called because
          # the controller's method_missing redirects the call!
          response_obj = [self.namespace].flatten.compact << var
          respond_with *response_obj
        end

    end # module InstanceMethods

    # =============================================================================
    # includes InstanceMethods on the target class
    def self.included base
      base.send :include, InstanceMethods
    end

  end # module Actions
end # module BootstrapAdmin
