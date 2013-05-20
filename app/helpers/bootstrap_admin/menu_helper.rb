module BootstrapAdmin::MenuHelper

  BOOTSTRAP_ADMIN_MENU_FILE = "config/bootstrap_admin_menu.yml"

  # =============================================================================
  # Builds the bootstrap_admin menu markup
  # @return [Markup] bootstrap_admin menu
  def bootstrap_admin_menu
    content_tag :ul, :class=>"nav" do
      bootstrap_admin_menu_items.map do |row|
        if row[:item].is_a? Array
          bootstrap_admin_menu_dropdown row
        elsif row[:item].is_a? Symbol
          bootstrap_admin_menu_separator row
        else
          bootstrap_admin_menu_item row
        end
      end.join.html_safe
    end # content_tag
  end

  private
    # =============================================================================
    def build_bootstrap_admin_menu_from_controller_names
      namespace = BootstrapAdmin.admin_namespace
      Dir["./app/controllers/#{namespace}/**/*.rb"].each do |controller|
        require controller
      end

      yml_menu = AdminController.descendants.map do |controller|
        ename = controller.name.demodulize.gsub("Controller","").singularize
        "- :item: #{ename}"
      end.join("\n")

      @bootstrap_admin_menu_items = YAML.load(yml_menu)
    end

    # =============================================================================
    def load_bootstrap_admin_menu_items
      @bootstrap_admin_menu_items = YAML.load_file(BOOTSTRAP_ADMIN_MENU_FILE)
      unless @bootstrap_admin_menu_items
        build_bootstrap_admin_menu_from_controller_names
      end
      @bootstrap_admin_menu_load_timestamp = Time.now
    end

    # =============================================================================
    def bootstrap_admin_menu_items
      if @bootstrap_admin_menu_load_timestamp.nil? or
         File.mtime(BOOTSTRAP_ADMIN_MENU_FILE) > @bootstrap_admin_menu_load_timestamp
        load_bootstrap_admin_menu_items
      end
      @bootstrap_admin_menu_items
    end

    # =============================================================================
    def bootstrap_admin_menu_item row
      if respond_to?(:cannot?) && cannot?(:read, row[:item].classify.constantize)
        "".html_safe
      else
        content_tag(:li) do
          bootstrap_admin_menu_link row
        end
      end
    end

    # =============================================================================
    def bootstrap_admin_menu_dropdown row
      content_tag(:li, :class=>"dropdown", :"data-dropdown"=>"dropdown") do
        bootstrap_admin_menu_link(row) +
        content_tag(:ul, :class=>"dropdown-menu") do
          row[:item].map do |sub|
            if sub[:item].is_a? Symbol
              bootstrap_admin_menu_separator sub
            else
              bootstrap_admin_menu_item sub
            end
          end.join.html_safe
        end
      end
    end

    # =============================================================================
    def bootstrap_admin_menu_separator row
      content_tag(:li, :class => row[:item]){""}
    end

    # =============================================================================
    def bootstrap_admin_menu_link row
      if row[:item].is_a? Array #then its a dropdown menu
        label = if row[:label].is_a? Symbol
                  t row[:label]
                else
                  row[:label]
                end
        url       = row[:url  ] || "#"
        css_class = row[:class] || "dropdown-toggle"
        data_attr = { :toggle => "dropdown" }


      else #then its a resource link.
        model_class = if row[:namespace]
                        "#{row[:namespace]}::#{row[:item]}".classify.constantize
                      else
                        row[:item].classify.constantize
                      end 

        model_symbol = row[:item].underscore.pluralize.to_sym

        label = if row[:label].is_a? Symbol
                  t row[:label]
                else
                  row[:label] || model_class.model_name.human.pluralize
                end

        url =  row[:url] || bootstrap_url_for(:controller => "#{row[:namespace] || BootstrapAdmin.admin_namespace}::#{row[:item]}".underscore.pluralize)
        css_class = row[:class]
        data_attr = {}
      end

      link_to label, url, :class => css_class, :data => data_attr
    end

end
