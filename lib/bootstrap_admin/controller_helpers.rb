module BootstrapAdmin
  module ControllerHelpers
    # =============================================================================
    module ClassMethods
      def bootstrap_admin config = {}
        @bootstrap_admin_config = BootstrapAdmin::ControllerConfig.new config

        self.responder = BootstrapAdmin::Responder
        add_bootstrap_admin_viewpath                # setup bootstrap_admin viewpath
        helper "bootstrap_admin"                    # add bootstrap_admin helpers
        helper "bootstrap_admin/paginator"          # add bootstrap_admin helpers
        self.send :include, BootstrapAdmin::Actions # add bootstrap_admin actions
        helper_method :bootstrap_admin_config
      end
      # ---------------------------------------------------------------------------
      private
        # -------------------------------------------------------------------------
        def add_bootstrap_admin_viewpath
          bootstrap_admin_viewpath = File.expand_path("../../../app/views/defaults", __FILE__)
          self.view_paths << ActionView::FileSystemResolver.new(
              bootstrap_admin_viewpath, ":action{.:locale,}{.:formats,}{.:handlers,}")
        end
        # -------------------------------------------------------------------------
    end
    # =============================================================================
    def bootstrap_admin_config
      self.class.instance_variable_get "@bootstrap_admin_config"
    end
    # -----------------------------------------------------------------------------
    def method_missing method, *args
      if bootstrap_admin_config.respond_to? method
        bootstrap_admin_config.send method, *args
      else
        super method, *args
      end
    end
    # -----------------------------------------------------------------------------
    def respond_to? method, include_private = false
      true if bootstrap_admin_config.respond_to? method
      super method, include_private
    end
    # -----------------------------------------------------------------------------

    def self.included base
      base.extend ClassMethods
    end
  end
end

ActionController::Base.class_eval { include BootstrapAdmin::ControllerHelpers }
