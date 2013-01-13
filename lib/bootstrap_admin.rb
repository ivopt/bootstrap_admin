# -----------------------------------------------------------------------------
require 'rails'
# -----------------------------------------------------------------------------
require 'bootstrap_admin/setup'
require 'bootstrap_admin/actions'
require 'bootstrap_admin/version'
require 'bootstrap_admin/responder'
require 'bootstrap_admin/controller_config'
require 'bootstrap_admin/controller_helpers'
# -----------------------------------------------------------------------------

module BootstrapAdmin
  # Your code goes here...
  class BootstrapAdminEngine < Rails::Engine
    config.autoload_paths << File.expand_path("../../app/helpers", __FILE__)
  end
  # =============================================================================
  mattr_accessor :menu_items
  # -----------------------------------------------------------------------------
  def setup
    yield self
  end
  # -----------------------------------------------------------------------------
end
