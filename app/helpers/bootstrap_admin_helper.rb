module BootstrapAdminHelper
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
