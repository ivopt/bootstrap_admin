module ActionDispatch::Routing
  class Mapper
    # =============================================================================
    # Defines the routes to the bootstrap_admin controllers of your app and also
    # defines a "admin root" route based on the bootstrap_admin namespace
    #
    # == Parameters
    # +options+:: regular route options for the "admin root"
    # +block+:: A block configuring namespaced routes, just like a regular
    #           namespace route block
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

  end # class Mapper
end # module ActionDispatch::Routing
