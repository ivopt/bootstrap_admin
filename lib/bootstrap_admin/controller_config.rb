module BootstrapAdmin
  class ControllerConfig
    # -----------------------------------------------------------------------------
    DEFAULTS = {
      :responder_formats => [:html, :json]
    }
    # -----------------------------------------------------------------------------
    attr_accessor :namespace
    attr_accessor :responder_formats
    attr_accessor :index_fields
    attr_accessor :show_fields
    attr_accessor :form_fields
    alias_method :edit_fields, :form_fields
    alias_method :new_fields, :form_fields
    # -----------------------------------------------------------------------------
    def initialize options = {}
      options      = DEFAULTS.merge options

      # responder namespace
      @namespace = options[:namespace] || BootstrapAdmin.admin_namespace

      # responder responder_formats
      @responder_formats = options[:responder_formats]

      # fields to be shown @ index
      # @index_fields = options[:index_fields]

      # fields to be shown @ show
      # @show_fields = options[:show_fields]
    end
    # -----------------------------------------------------------------------------
    # -----------------------------------------------------------------------------
  end
end
