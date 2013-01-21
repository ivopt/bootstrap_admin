module ActionDispatch::Routing
  class Mapper
    # -----------------------------------------------------------------------------
    def bootstrap_admin options = {}, &block
      admin_namespace = options.delete(:namespace) || BootstrapAdmin.admin_namespace
      BootstrapAdmin.admin_namespace = admin_namespace

      root_options = BootstrapAdmin.admin_root_options.
                      merge({:to => admin_namespace.to_s}).
                      merge(options)
      resource admin_namespace, root_options

      if block_given?
        namespace admin_namespace do
          block.call
        end
      end
    end # bootstrap_admin
    # -----------------------------------------------------------------------------
  end
end
