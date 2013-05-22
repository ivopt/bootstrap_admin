module BootstrapAdmin
  class Responder < ActionController::Responder
    # =============================================================================
    # Responds to any format...
    def to_format
      render @format        => format_resource(@resource, @format),
             :status        => status_for_resource(@resource),
             :content_type  => content_type_for(@format)
    end

    # =============================================================================
    # Responds to HTML format
    #
    # It sets flash messages, handles search, sets pagination (@paginator)
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
        redirect_to :action => :show, :id => resource.id

      else
        if delete?
          controller.flash[:success] = I18n.t("helpers.messages.destroy.success", :model => resource.class.model_name.human)
          redirect_to :action => :index
        else
          super
        end
      end
    end

    private
      # =============================================================================
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

      # =============================================================================
      def resource_count resource
        values = resource.includes_values
        to_remove = resource.reflect_on_all_associations.select{|a| a.options[:polymorphic]}.map &:name
        resource.includes_values -= to_remove
        count = resource.count
        resource.includes_values = values

        return count
      end

      # =============================================================================
      def process_search resource
        result = resource
        fields = search_fields resource

        if controller.params[:q] and !fields.blank?
          conditions = fields.map do |field|
            if field.is_a? Symbol or field.is_a? String
              "#{resource.table_name}.#{field} like ?"

            elsif field.is_a? Hash
              resource, sconds = process_search_hash(resource, field)
              sconds
            end
          end.flatten.compact

          params = ["%#{controller.params[:q]}%"] * conditions.count
          result = resource.where(conditions.join(" OR "), *params)
        end

        result
      end

      # =============================================================================
      def search_fields resource
        if controller.searchable_fields.blank?
          accessible  = resource.accessible_attributes.reject &:blank?
          text_fields = resource.columns.
                                 select{|c| [:string, :text].include? c.type}.
                                 map(&:name)
          text_fields & accessible
        else
          controller.searchable_fields
        end
      end

      # =============================================================================
      def process_search_hash resource, hash
        conditions = hash.keys.map do |key|
          assoc = resource.reflect_on_association(key)
          if assoc.options[:polymorphic]
            next
          else
            resource = resource.joins <<-SQL
              LEFT JOIN #{assoc.table_name}
                on (#{resource.table_name}.#{assoc.foreign_key} = #{assoc.klass.table_name}.#{assoc.klass.primary_key})
            SQL
            if hash[key].is_a? Symbol or hash[key].is_a? String
              "#{assoc.table_name}.#{hash[key]} like ?"

            elsif hash[key].is_a? Array
              hash[key].map{|col| "#{assoc.table_name}.#{col} like ?" }

            elsif hash[key].is_a? Hash
              process_search_hash(resource, hash[key])

            end
          end
        end
        return resource, conditions
      end

      # =============================================================================
      def content_type_for format
        "application/#{format}"
      end

      # =============================================================================
      def format_resource resource, format
        if resource.is_a?(ActiveRecord::Base) and not resource.valid?
          resource.errors.send "to_#{format}"
        else
          resource.send "to_#{format}"
        end
      end

      # =============================================================================
      def status_for_resource(resource)
        if resource.is_a?(ActiveRecord::Base) and not resource.valid?
          403
        else
          200
        end
      end

  end # class Responder
end # module BootstrapAdmin

