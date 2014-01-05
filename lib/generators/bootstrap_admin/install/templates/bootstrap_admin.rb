BootstrapAdmin.setup do |config|

  # ==> Admin namespace configuration
  # Configure namespace used for the scope of this admin
  # Default value: :admin
  config.admin_namespace = "<%= namespace_parsed %>"

  # ==> Paginator configuration
  # Configure the number of results shown per page by the paginator.
  # Default value: 10
  # config.paginator_page_size = 10

  # ==> UI Styles
  # Configure the css class names that each action wrapper will have
  # Default value: {index: %w(table-bordered table-striped)}
  # config.ui_styles[:index] << "my_awesome_style_class"

end
