module BootstrapAdmin
  class Responder < ActionController::Responder
    # -----------------------------------------------------------------------------
    def to_format
      render @format        => format_resource(@resource, @format),
             :status        => status_for_resource(@resource),
             :content_type  => content_type_for(@format)
    end
    # -----------------------------------------------------------------------------
    def to_html
      if get? && resource.is_a?(ActiveRecord::Relation)
        items = process_search resource
        items, paginator = paginate items

        controller.instance_variable_set("@#{controller.controller_name}", items)
        controller.instance_variable_set("@paginator", paginator)
        if request.xhr?
          render controller.params[:action], layout: false
        end
      elsif resource.is_a?(ActiveRecord::Base) && (post? || put?) && resource.valid?
        message = if post?
                    'helpers.messages.create.success'
                  else #put?
                    'helpers.messages.update.success'
                  end
        controller.flash[:success] = I18n.t(message, :model => resource.class.model_name.human)
        redirect_to @resources

      else
        if delete?
          controller.flash[:success] = I18n.t("helpers.messages.destroy.success", :model => resource.class.model_name.human)
        end
        super
      end
    end
    # -----------------------------------------------------------------------------
    private
    # -----------------------------------------------------------------------------
    # =============================================================================
    # -----------------------------------------------------------------------------
    def paginate resource
      current_page = (controller.params[:page] || 1).to_i
      per_page     = (controller.params[:pp]   || BootstrapAdmin.paginator_page_size).to_i
      count        = resource_count(resource)
      pages        = (count.to_f/per_page).ceil
      paginator = {
        :current_page => current_page,
        :count        => count,
        :pages        => pages > 0 ? pages : 1
      }
      items = resource.offset( (current_page-1)*per_page ).limit(per_page)

      return items, paginator
    end
    # -----------------------------------------------------------------------------
    def resource_count resource
      values = resource.includes_values
      to_remove = resource.reflect_on_all_associations.select{|a| a.options[:polymorphic]}.map &:name
      resource.includes_values -= to_remove
      count = resource.count
      resource.includes_values = values

      return count
    end
    # -----------------------------------------------------------------------------
    def process_search resource
      result = resource
      if controller.params[:q] and !resource.searchable_columns.blank?
        conditions = resource.searchable_columns.map do |column|
          if column.is_a? Symbol or column.is_a? String
            "#{resource.table_name}.#{column} like ?"

          elsif column.is_a? Hash
            process_search_hash(resource, column)
          end
        end.flatten.compact

        params = ["%#{controller.params[:q]}%"] * conditions.count
        result = resource.where(conditions.join(" OR "), *params)
      end

      result
    end
    # -----------------------------------------------------------------------------
    def process_search_hash resource, hash
      hash.keys.map do |key|
        assoc = resource.reflect_on_association(key)
        if assoc.options[:polymorphic]
          next
        else
          resource.includes key
          if hash[key].is_a? Symbol or hash[key].is_a? String
            "#{assoc.table_name}.#{hash[key]} like ?"

          elsif hash[key].is_a? Array
            hash[key].map{|col| "#{assoc.table_name}.#{col} like ?" }

          elsif hash[key].is_a? Hash
            process_search_hash(resource, hash[key])

          end
        end
      end
    end
    # -----------------------------------------------------------------------------
    # =============================================================================
    # -----------------------------------------------------------------------------
    def content_type_for format
      "application/#{format}"
    end
    # -----------------------------------------------------------------------------
    def format_resource resource, format
      if resource.is_a?(ActiveRecord::Base) and not resource.valid?
        resource.errors.send "to_#{format}"
      else
        resource.send "to_#{format}"
      end
    end
    # -----------------------------------------------------------------------------
    def status_for_resource(resource)
      if resource.is_a?(ActiveRecord::Base) and not resource.valid?
        403
      else
        200
      end
    end
    # -----------------------------------------------------------------------------
    # =============================================================================
    # -----------------------------------------------------------------------------
  end
end
