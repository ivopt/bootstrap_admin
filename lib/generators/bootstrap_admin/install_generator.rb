module BootstrapAdmin
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../../templates", __FILE__)

      class_option :orm

      desc "Copies bootstrap_admin's initializer and  menu config file to your application."
      def copy_initializer
        copy_file "bootstrap_admin.rb", "config/initializers/bootstrap_admin.rb"
      end

      def copy_bootstrap_admin_menu
        copy_file "../../../config/bootstrap_admin_menu.yml", "config/bootstrap_admin_menu.yml"
      end

      # def show_readme
      #   readme "README" if behavior == :invoke
      # end
    end
  end
end
