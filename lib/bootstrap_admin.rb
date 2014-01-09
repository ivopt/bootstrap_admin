# -----------------------------------------------------------------------------
require 'rails'
require 'haml'
require 'simple_form'
# -----------------------------------------------------------------------------
require 'active_support/dependencies'
# -----------------------------------------------------------------------------
require 'bootstrap_admin/actions'
require 'bootstrap_admin/active_record_extensions'
require 'bootstrap_admin/attribute'
require 'bootstrap_admin/version'
require 'bootstrap_admin/responder'
require 'bootstrap_admin/controller_config'
require 'bootstrap_admin/controller_helpers'
require 'bootstrap_admin/routes'
# -----------------------------------------------------------------------------
require File.expand_path("../../config/initializers/simple_form.rb", __FILE__)
# -----------------------------------------------------------------------------

# Bootstrap admin eases the tedious task of building admin interfaces
module BootstrapAdmin
  class BootstrapAdminEngine < Rails::Engine
    config.autoload_paths << File.expand_path("../../app/helpers", __FILE__)
  end
  # =============================================================================
  # Defines the namespace where all the "bootstrap_admin" magic happens
  mattr_accessor :admin_namespace
  @@admin_namespace = :admin

  # =============================================================================
  # mattr_accessor :admin_root_url
  # @@admin_root_url = nil

  # =============================================================================
  # Defines the route options for the "admin root"
  mattr_accessor :admin_root_options
  @@admin_root_options = {:only => :show}

  # =============================================================================
  # Defines de number of items per page
  mattr_accessor :paginator_page_size
  @@paginator_page_size = 10

  # =============================================================================
  #
  mattr_accessor :ui_styles
  @@ui_styles = {
    index: %w(table-bordered table-striped)
  }
  # =============================================================================
  # Use Glyphicons in buttons, default = true
  mattr_writer :use_glyphicons
  @@use_glyphicons = true
  def self.use_glyphicons?; @@use_glyphicons; end
  #Customize buttons classes or glyphicons for action links
  mattr_accessor :default_actions_params
  @@default_actions_params = {
    
    :new => {
              :button_class => 'btn btn-primary', 
              :glyphicon_class => 'glyphicon glyphicon-file'
    },
    :create => { :button_class => 'btn btn-primary', 
                 :glyphicon_class => 'glyphicon glyphicon-file'
    },
    :show => {
              :button_class => 'btn btn-default', 
              :glyphicon_class => 'glyphicon glyphicon-eye-open'
    },
    :edit => {
              :button_class => 'btn btn-default', 
              :glyphicon_class => 'glyphicon glyphicon-edit'
    }, 
    :destroy => {
               :link_options => { :confirm => I18n.t(:confirm), 
                                  :method => :delete
                },
                :button_class => 'btn btn-danger', 
                :glyphicon_class => 'glyphicon glyphicon-trash'
    },
    :back => {
              :button_class => 'btn btn-default back', 
              :glyphicon_class => 'glyphicon glyphicon-arrow-left'
    },
    :form => {
              :button_class => 'btn btn-primary'
    }
  }
   
   
  # =============================================================================
  # Setup BootstrapAdmin
  # Run rails generate bootstrap_admin:install
  # to create a fresh initializer with all configuration values.
  def self.setup
    yield self
  end

end
