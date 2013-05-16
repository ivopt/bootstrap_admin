module BootstrapAdmin
  # Defines each controllers specific configuration
  class ControllerConfig
    DEFAULTS = {
      :responder_formats => [:html, :json]
    }

    # controller's namespace
    attr_accessor :namespace

    # Responded formats
    attr_accessor :responder_formats

    # Fields to be used on the index action
    attr_accessor :index_fields

    # Fields to be used on the show action
    attr_accessor :show_fields

    # Fields to be used on form (edit/new/create/update) actions
    attr_accessor :form_fields
    alias_method :edit_fields,   :form_fields
    alias_method :new_fields,    :form_fields
    alias_method :create_fields, :form_fields
    alias_method :update_fields, :form_fields

    # Fields to be used on ALL actions
    # These are used when none of the {action}_fields are defined
    attr_accessor :action_fields

    # Searchable fields
    attr_accessor :searchable_fields

    # Available Actions
    attr_accessor :available_actions

    # Name of the model to be used on this controller (to support namespaced models)
    attr_accessor :model_name

    # =============================================================================
    def initialize options = {}
      options      = DEFAULTS.merge options

      # namespace
      @namespace = options[:namespace] || BootstrapAdmin.admin_namespace

      # responder responder_formats
      @responder_formats = options[:responder_formats]

      # fields to be shown @ index
      # @index_fields = options[:index_fields]

      # fields to be shown @ show
      # @show_fields = options[:show_fields]

      @available_actions = [:new, :show, :edit, :destroy]
    end
    # =============================================================================
  end
end
