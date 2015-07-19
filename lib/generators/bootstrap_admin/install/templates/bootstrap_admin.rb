BootstrapAdmin.setup do |config|

  # ==> Admin namespace configuration
  # Configure namespace used for the scope of this admin
  # Default value: :admin
  config.admin_namespace = "<%= namespace_parsed %>"

  # ==> Paginator configuration
  # Configure the number of results shown per page by the paginator.
  # Default value: 10
  #
  # config.paginator_page_size = 10

  # ==> UI Styles
  # Configure the css class names that each action wrapper will have
  # Default value: {index: %w(table-bordered table-striped)}
  #
  # config.ui_styles[:index] << "my_awesome_style_class"

  # ==> Default ignored fields
  # Define the fields that the automatic view generator should ignore
  # when building the index view and the new/edit forms.
  # Default value: %i(id created_at updated_at)
  #
  # config.default_ignored_fields += %i(some other fields)

end
