module BootstrapAdminHelper
  # -----------------------------------------------------------------------------
  def show_field(item, field, &block)
    content_tag :p do
      content_tag(:b) do
        item.class.human_attribute_name(field) + ": "
      end +
      if block_given?
        capture(&block)
      else
        val = item.send(field)
        if val.class.name =~ /(TrueClass|FalseClass)/
          content_tag(:span, :class => "checkbox #{val.to_s}") do
            content_tag(:span, :class=>"icon"){""}
          end
        elsif val.is_a? Array
          content_tag :ul do
            val.map do |uniq_val|
              content_tag(:li, uniq_val.to_s)
            end.join.html_safe
          end
        else
          val.to_s
        end
      end
    end.html_safe
  end
  # -----------------------------------------------------------------------------
  def model_for(controller)
    collection_name_for(controller).classify.constantize
  end
  #-------------------------------------------------------------------------------
  def model_instance_for(controller)
    name = collection_name_for(controller).singularize
    instance_variable_get("@#{name}")
  end
  #-------------------------------------------------------------------------------
  def collection_for(controller)
    name = collection_name_for(controller)
    instance_variable_get("@#{name}")
  end
  #-------------------------------------------------------------------------------
  def model_name_for(controller)
    model_for(controller).model_name.underscore
  end
  #-------------------------------------------------------------------------------
  def collection_name_for(controller)
    controller.class.name.sub("Controller", "").underscore.split('/').last
  end
  #-------------------------------------------------------------------------------
  def real_attribute_name(attribute)
    if attribute.end_with? "_ids"
      "#{attribute.chomp("_ids")}s".to_sym
    elsif attribute.end_with? "_id"
      attribute.chomp("_id").to_sym
    else
      attribute.to_sym
    end
  end
  #-------------------------------------------------------------------------------
end
