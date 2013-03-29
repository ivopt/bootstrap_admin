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

    # The actual action methods!
    module InstanceMethods
      # Default index action, uses the controllers responder
      def index
        namespaced_response collection
      end

      # Default show action, uses the controllers responder
      def show
        namespaced_response instance
      end

      # Creates a new record
      def create
        instance model_class.create(params[model_name])
        instance.save
        namespaced_response instance
      end

      # Updates the current record
      def update
        instance.update_attributes params[model_name]
        namespaced_response instance
      end

      # Destroys the current record
      def destroy
        instance.destroy
        namespaced_response instance
      end
      # -----------------------------------------------------------------------------
      # -----------------------------------------------------------------------------
      protected
        # -----------------------------------------------------------------------------
        # @return [String] model name based on the controller's name
        def model_name
          collection_name.singularize
        end
        # -----------------------------------------------------------------------------
        # @return [ActiveRecord::Base] model class based on the controller's name
        def model_class
          model_name.classify.constantize
        end
        # -----------------------------------------------------------------------------
        # @return [ActiveRecord::Base] instance
        def instance instance_var = nil
          if instance_var
            instance_variable_set "@#{collection_name.singularize}", instance_var
          else
            unless ivar = instance_variable_get("@#{collection_name.singularize}")
              ivar = model_class.find params[:id]
              instance_variable_set "@#{collection_name.singularize}", ivar
            end
            ivar
          end
        end
        # -----------------------------------------------------------------------------
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
        # -----------------------------------------------------------------------------
        # @return [String] collection name based on the controller name
        def collection_name
          self.class.name.sub("Controller", "").underscore.split('/').last
        end
      # -----------------------------------------------------------------------------
      private
        # -----------------------------------------------------------------------------
        # Prepares a response using the controllers reponder.
        def namespaced_response var
          # namespace is a property of BootstrapAdmin::Config and gets called because
          # the controller's method_missing redirects the call!
          response_obj = [self.namespace].flatten.compact << var
          respond_with *response_obj
        end
      # -----------------------------------------------------------------------------
    end # module InstanceMethods
    # -----------------------------------------------------------------------------
    ###############################################################################
    def self.included base
      # base.extend ClassMethods
      base.send :include, InstanceMethods
    end
    ###############################################################################
  end # module Actions
end # module BootstrapAdmin
