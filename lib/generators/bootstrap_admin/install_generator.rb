module BootstrapAdmin
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.dirname(__FILE__)

      desc "Copy the default bootstrap_admin_menu.yml file to your application."
      class_option :orm

      # def copy_initializer
      #   template "devise.rb", "config/initializers/devise.rb"
      # end

      def copy_bootstrap_admin_menu
        copy_file "../../../config/bootstrap_admin_menu.yml", "config/bootstrap_admin_menu.yml"
      end

      # def show_readme
      #   readme "README" if behavior == :invoke
      # end
    end
  end
end
