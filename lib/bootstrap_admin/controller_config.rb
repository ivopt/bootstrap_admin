module BootstrapAdmin
  class ControllerConfig
    # -----------------------------------------------------------------------------
    DEFAULTS = {
      :namespace => :admin
    }
    # -----------------------------------------------------------------------------
    attr_reader :namespace
    # -----------------------------------------------------------------------------
    def initialize options = {}
      options      = DEFAULTS.merge options

      # responder namespace
      @namespace = options[:namespace]
    end
    # -----------------------------------------------------------------------------
  end
end
