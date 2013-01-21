require 'active_support/dependencies'

module BootstrapAdmin
  # -----------------------------------------------------------------------------
  mattr_accessor :admin_namespace
  @@admin_namespace = :admin
  # -----------------------------------------------------------------------------
  # mattr_accessor :admin_root_url
  # @@admin_root_url = nil
  # -----------------------------------------------------------------------------
  mattr_accessor :admin_root_options
  @@admin_root_options = {:only => :show}
  # -----------------------------------------------------------------------------
  def self.setup
    yield self
  end
  # -----------------------------------------------------------------------------
end
