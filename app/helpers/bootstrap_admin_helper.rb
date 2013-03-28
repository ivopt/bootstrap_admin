module BootstrapAdminHelper
  #-------------------------------------------------------------------------------
  # This re-implementation of link_to simply looks at the link label and if it
  # falls under certain conditions, then it tries to create a label and/or url
  # accordingly. Else works normally
  # Ex: Assuming locale is set to PT
  #  link_to :Show, @document 
  #    # <a href='/documents/1'>Ver</a>
  #  link_to Document
  #    # <a href='/documents'>Documentos</a>
  #  link_to [:edit, @document]
  #    # <a href='/document/1/edit'>Editar Documento</a>
  def link_to(*args, &block)
    super(*args, &block) if block_given?

    # When args[0] is a symbol, then just translate the symbol...
    if args[0].is_a? Symbol
      super(t(args[0]), *args[1..-1])

    # when arg[0] is a ActiveRecord class...
    elsif args[0].is_a?(Class) and args[0] < ActiveRecord::Base
      label = args[0].model_name.human.pluralize
      if args.length == 1
        controller_name = args[0].name.underscore.pluralize
        super(label, url_for(controller: controller_name, action: "index"))
      else
        super(label, *args[1..-1])
      end

    elsif args[0].is_a?(Array) && args[0][0].is_a?(Symbol) && args[0][1] < ActiveRecord::Base
      link_content = t("helpers.submit.#{args[0][0]}", :model => args[0][1].model_name.human)
      super(link_content, *args[1..-1])
    else
      super(*args)
    end
  end
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
