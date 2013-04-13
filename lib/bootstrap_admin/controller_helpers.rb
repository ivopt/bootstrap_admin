module BootstrapAdmin
  module ControllerHelpers
    # =============================================================================
    module ClassMethods
      # Controller Macro to define and configure bootstrap_admin
      #
      # When you run this macro on a controller, it:
      #   * sets BootstrapAdmin::Responder as the controller's responder
      #   * includes BootstrapAdmin::Actions, defining the controller's default actions
      #   * adds helpers (bootstrap_admin, bootstrap_admin/paginator and bootstrap_admin/menu)
      #   * adds the bootstrap_admin default views to the viewpath
      #
      # == Parameters
      # +block+:: an optional code block that will receive an instance of BootstrapAdmin::ControllerConfig
      #           to configure controller specific stuff, such as index_fields, etc..
      def bootstrap_admin &block
        @bootstrap_admin_config = BootstrapAdmin::ControllerConfig.new # config
        if block_given?
          block.call @bootstrap_admin_config
        end

        self.respond_to *@bootstrap_admin_config.responder_formats
        self.responder = BootstrapAdmin::Responder
        # setup bootstrap_admin viewpath
        add_bootstrap_admin_viewpath

        # add bootstrap_admin helpers
        helper "bootstrap_admin"
        helper "bootstrap_admin/paginator"
        helper "bootstrap_admin/menu"

        layout "bootstrap_admin"

        # add bootstrap_admin actions
        self.send :include, BootstrapAdmin::Actions
        helper_method :bootstrap_admin_config
      end

      private
        # =============================================================================
        def add_bootstrap_admin_viewpath
          bootstrap_admin_viewpath = File.expand_path("../../../app/views/defaults", __FILE__)
          self.view_paths << ActionView::FileSystemResolver.new(
              bootstrap_admin_viewpath, ":action{.:locale,}{.:formats,}{.:handlers,}")
        end

    end # module ClassMethods

    # =============================================================================
    # Helper method - provides access to the controller config on the views
    def bootstrap_admin_config
      self.class.instance_variable_get "@bootstrap_admin_config"
    end

    # =============================================================================
    # Eases the access to config properties via bootstrap_admin_config
    def method_missing method, *args
      if bootstrap_admin_config.respond_to? method
        bootstrap_admin_config.send method, *args
      else
        super method, *args
      end
    end

    # self responds_to bootstrap_admin_config methods via method_missing!
    def respond_to? method, include_private = false
      true if bootstrap_admin_config.respond_to? method
      super method, include_private
    end

    # =============================================================================
    def self.included base
      base.extend ClassMethods
    end
  end
end

ActionController::Base.class_eval { include BootstrapAdmin::ControllerHelpers }
