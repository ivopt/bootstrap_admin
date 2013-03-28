# -----------------------------------------------------------------------------
require 'rails'
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

module BootstrapAdmin
  # Your code goes here...
  class BootstrapAdminEngine < Rails::Engine
    config.autoload_paths << File.expand_path("../../app/helpers", __FILE__)
  end
  # =============================================================================
  mattr_accessor :admin_namespace
  @@admin_namespace = :admin
  # -----------------------------------------------------------------------------
  # mattr_accessor :admin_root_url
  # @@admin_root_url = nil
  # -----------------------------------------------------------------------------
  mattr_accessor :admin_root_options
  @@admin_root_options = {:only => :show}
  # -----------------------------------------------------------------------------
  mattr_accessor :paginator_page_size
  @@paginator_page_size = 10
  # -----------------------------------------------------------------------------
  def self.setup
    yield self
  end
  # -----------------------------------------------------------------------------
end
