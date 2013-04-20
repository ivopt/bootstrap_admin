module BootstrapAdmin
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)

      class_option :namespace, :type => :string, :default => "admin", :desc => "Namespace used by the bootstrap_admin"

      def copy_initializer
        template "bootstrap_admin.rb", "config/initializers/bootstrap_admin.rb"
      end

      def copy_bootstrap_admin_menu
        copy_file "bootstrap_admin_menu.yml", "config/bootstrap_admin_menu.yml"
      end

      def asset_configuration
        empty_directory "app/assets/javascripts/#{namespace_parsed}"
        create_file "app/assets/javascripts/#{namespace_parsed}.js" do
          <<-JS_INFO.strip_heredoc
            // Loads all bootstrap_admin javascripts
            //= require bootstrap_admin
            //= require_tree ./#{namespace_parsed}
          JS_INFO
        end

        empty_directory "app/assets/stylesheets/#{namespace_parsed}"
        create_file "app/assets/stylesheets/#{namespace_parsed}.css" do
          <<-CSS_INFO.strip_heredoc
            /*
             *= require bootstrap_admin.css
             *= require_self
             *= require_tree ./#{namespace_parsed}
             */
          CSS_INFO
        end
      end

      def create_admin_controller
        create_file "app/controllers/#{namespace_parsed}_controller.rb" do
          <<-RUBY.strip_heredoc
            class #{options.namespace.classify}Controller < ApplicationController
              layout "bootstrap_admin"
              helper "bootstrap_admin/menu"
            end
          RUBY
        end
      end

      private

      def namespace_parsed
        options.namespace.underscore
      end
    end
  end
end
