module BootstrapAdmin
  class ControllerConfig
    # -----------------------------------------------------------------------------
    DEFAULTS = {
      :responder_formats => [:html, :json]
    }
    # -----------------------------------------------------------------------------
    attr_reader :namespace
    attr_reader :responder_formats
    # -----------------------------------------------------------------------------
    def initialize options = {}
      options      = DEFAULTS.merge options

      # responder namespace
      @namespace = options[:namespace] || BootstrapAdmin.admin_namespace

      # responder responder_formats
      @responder_formats = options[:responder_formats]
    end
    # -----------------------------------------------------------------------------
  end
end
