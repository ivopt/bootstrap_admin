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

  # ==> Action Buttons Styles
  # Disable or change glyphicons or the bootstrap buttons classes,
  # By default glyphicons are enabled and configured just for index actions inside each row,
  # but if you disabled it, the button will contain the action translation(ex: t(:show))
  #
  # config.default_actions_params = {
  #   :new => {
  #             :button_class => 'btn btn-primary', 
  #             :glyphicon_class => 'glyphicon glyphicon-file'
  #   },
  #   :create => { :button_class => 'btn btn-primary', 
  #                :glyphicon_class => 'glyphicon glyphicon-file'
  #   },
  #   :show => {
  #             :button_class => 'btn btn-default', 
  #             :glyphicon_class => 'glyphicon glyphicon-eye-open'
  #   },
  #   :edit => {
  #             :button_class => 'btn btn-default', 
  #             :glyphicon_class => 'glyphicon glyphicon-edit'
  #   }, 
  #   :destroy => {
  #              :link_options => { :confirm => I18n.t(:confirm), 
  #                                 :method => :delete
  #               },
  #               :button_class => 'btn btn-danger', 
  #               :glyphicon_class => 'glyphicon glyphicon-trash'
  #   },
  #   :back => {
  #             :button_class => 'btn btn-default back', 
  #             :glyphicon_class => 'glyphicon glyphicon-arrow-left'
  #   },
  #   :form => {
  #             :button_class => 'btn btn-primary'
  #   }
  # }
end
