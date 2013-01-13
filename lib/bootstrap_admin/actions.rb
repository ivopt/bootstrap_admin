module BootstrapAdmin
  module Actions
    # -----------------------------------------------------------------------------
    # module ClassMethods
    #   def responder_namespace namespace = nil
    #     @namespace = namespace
    #   end
    # end
    # -----------------------------------------------------------------------------
    # =============================================================================
    # -----------------------------------------------------------------------------
    module InstanceMethods
      # -----------------------------------------------------------------------------
      def index
        namespaced_response collection
      end
      # -----------------------------------------------------------------------------
      def show
        namespaced_response instance
      end
      # -----------------------------------------------------------------------------
      def create
        instance model_class.create(params[model_name])
        instance.save
        namespaced_response instance
      end
      # -----------------------------------------------------------------------------
      def update
        instance.update_attributes params[model_name]
        namespaced_response instance
      end
      # -----------------------------------------------------------------------------
      def destroy
        instance.destroy
        namespaced_response instance
      end
      # -----------------------------------------------------------------------------
      # -----------------------------------------------------------------------------
      protected
        # -----------------------------------------------------------------------------
        def model_name
          collection_name.singularize
        end
        # -----------------------------------------------------------------------------
        def model_class
          model_name.classify.constantize
        end
        # -----------------------------------------------------------------------------
        def instance instance_var = nil
          if instance_var
            instance_variable_set "@#{collection_name.singularize}", instance_var
          else
            instance_variable_get "@#{collection_name.singularize}"
          end
        end
        # -----------------------------------------------------------------------------
        def collection collection_var = nil
          if collection_var
            instance_variable_set "@#{collection_name}", collection_var
          else
            instance_variable_get "@#{collection_name}"
          end
        end
        # -----------------------------------------------------------------------------
        def collection_name
          self.class.name.sub("Controller", "").underscore.split('/').last
        end
      # -----------------------------------------------------------------------------
      private
        # -----------------------------------------------------------------------------
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
