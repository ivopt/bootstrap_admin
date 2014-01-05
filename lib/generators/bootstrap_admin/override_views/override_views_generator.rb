module BootstrapAdmin
  module Generators
    class OverrideViewsGenerator < Rails::Generators::Base
      # =============================================================================
      argument :resource, :type     => :string,
                          :default  => "defaults",
                          :banner   => "defaults or <resource>"

      # =============================================================================
      argument :actions,  :type     => :array,
                          :optional => true,
                          :banner   => "index show edit ...",
                          :default  => %w(index show new edit)

      # =============================================================================
      class_option :namespace,  :type    => :string,
                                :default => "admin",
                                :desc    => "Namespace used by the bootstrap_admin"

      source_root File.expand_path("../templates", __FILE__)

      # =============================================================================
      def copy_views
        folder_base = "#{Rails.root}/app/views/#{BootstrapAdmin.admin_namespace}"
        target_dir = if "defaults" == resource
                       "#{folder_base}/defaults" # global view folder
                     else
                       "#{folder_base}/#{resource.tableize}" # resource view folder
                     end

        empty_directory target_dir
        _copy_views_ target_dir, actions
      end

      # =============================================================================
      protected
        VIEW_DEPENDENCIES = {
          "index"        => ['index', '_index', '_paginator', '_search_box'],
          "show"         => ['show' , '_show'],
          "new"          => ['new'  , ['_form', '_new_form'] , ['_form_fields', '_new_form_fields' ]],
          "edit"         => ['edit' , ['_form', '_edit_form'], ['_form_fields', '_edit_form_fields']],
          "new_and_edit" => ['new'  , 'edit', '_form', '_form_fields']
        }

        def _copy_views_ target_dir, actions
          if actions & %w[new edit] == %w[new edit]
            actions = actions - %w[new edit] + %w[new_and_edit]
          end

          actions.each do |action|
            VIEW_DEPENDENCIES[action].each do |view_name, rename_to|
              view   = "#{BootstrapAdmin.root_dir}/app/views/defaults/#{view_name}.html.haml"
              target = "#{target_dir}/#{rename_to || view_name}.html.haml"
              copy_file view, target
            end
          end
        end

    end # class OverrideViewsGenerator
  end # module Generators
end # module BootstrapAdmin
