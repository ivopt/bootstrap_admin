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
    end
  end

  private
    # =============================================================================
    def load_bootstrap_admin_menu_items
      @bootstrap_admin_menu_items = YAML.load_file(BOOTSTRAP_ADMIN_MENU_FILE)
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
    def bootstrap_admin_menu_item(row)
      if can? :read, row[:item].classify.constantize
        content_tag(:li) do bootstrap_admin_menu_link(row) end
      else
        "".html_safe
      end
    end

    # =============================================================================
    def bootstrap_admin_menu_dropdown(row)
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
    def bootstrap_admin_menu_separator(row)
      content_tag(:li, :class => row[:item]){""}
    end

    # =============================================================================
    def bootstrap_admin_menu_link(row)
      if row[:item].is_a? Array #then its a dropdown menu
        label     = row[:label]
        url       = row[:url  ] || "#"
        css_class = row[:class] || "dropdown-toggle"
        data_attr = { :toggle => "dropdown" }

      else #then its a resource link.
        model_class  = row[:item].classify.constantize
        model_symbol = row[:item].demodulize.underscore.pluralize.to_sym

        label     = row[:label] || model_class.model_name.human.pluralize
        url       = row[:url  ] || [BootstrapAdmin.admin_namespace, model_symbol]
        css_class = row[:class]
        data_attr = {}
      end

      link_to label, url, :class => css_class, :data => data_attr
    end

end
