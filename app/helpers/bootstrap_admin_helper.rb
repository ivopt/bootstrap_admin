module BootstrapAdminHelper
  # -----------------------------------------------------------------------------
  def show_field item, field, &block
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
  # -----------------------------------------------------------------------------
  def model_for controller
    collection_name_for(controller).classify.constantize
  end
  #-------------------------------------------------------------------------------
  def model_instance_for controller
    name = collection_name_for(controller).singularize
    instance_variable_get "@#{name}"
  end
  #-------------------------------------------------------------------------------
  def collection_for controller
    name = collection_name_for controller
    instance_variable_get "@#{name}"
  end
  #-------------------------------------------------------------------------------
  def model_name_for controller
    model_for(controller).model_name.underscore
  end
  #-------------------------------------------------------------------------------
  def collection_name_for controller
    controller.class.name.sub("Controller", "").underscore.split('/').last
  end
  #-------------------------------------------------------------------------------
  #-------------------------------------------------------------------------------
  def real_attribute_name attribute
    if attribute.match /(.+)_(?:id)(s)?$/
      "#{$1}#{$2}".to_sym
    else
      attribute.to_sym
    end
  end
  #-------------------------------------------------------------------------------
  def attributes
    return @attributes if @attributes

    model_klass = model_for controller
    bootstrap_admin_config_field = bootstrap_admin_config.send("#{params[:action]}_fields")
    attributes = if "index" == params[:action] && bootstrap_admin_config_field
      bootstrap_admin_config_field
    else
      model_klass.accessible_attributes.
        reject(&:blank?).
        map{|att| real_attribute_name att }
    end

    @attributes = attributes.map do |att|
      BootstrapAdmin::Attribute.new(
        att,
        model_klass.human_attribute_name(att),
        model_klass.type_of(att)
      )
    end
  end
  #-------------------------------------------------------------------------------
end
