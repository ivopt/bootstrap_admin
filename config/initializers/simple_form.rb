# MONKEY PATCHES FOR FIXES IN SIMPLE FORM TO WORK WITH BOOTSTRAP3
module SimpleForm
  @@input_class = nil
  mattr_accessor :input_class
end

SimpleForm::Inputs::Base.class_eval do

  def input_html_classes
    if self.class.name == "SimpleForm::Inputs::CollectionRadioButtonsInput" || self.class.name == "SimpleForm::Inputs::BooleanInput"
      SimpleForm.additional_classes_for(:input) { additional_classes  }
    else
      SimpleForm.additional_classes_for(:input) { additional_classes + [SimpleForm.input_class] }
    end
  end

end

SimpleForm::Inputs::CollectionRadioButtonsInput.class_eval do
  def item_wrapper_class
      ""
  end
end
#####################################################################
SimpleForm.setup do |config|

  config.wrappers :default,
                  :tag         => 'div',
                  :class       => [:"form-group"],
                  :label_class => 'control-label',
                  :hint_class  => :field_with_hint,
                  :error_class => :error do |wrapper|

    wrapper.use :label

    wrapper.wrapper :tag => 'div', :class => 'row' do |wrapper1|
      wrapper1.wrapper :tag => 'div', :class => 'col-xs-4' do |wrapper2|
        wrapper2.use :input
      end
    end

    wrapper.use :hint, :wrap_with => { :tag => :span, :class => :hint }
    #b.use :error, :wrap_with => { :tag => :span, :class => :error }
    
  end

  config.wrappers :full_width,
                  :tag         => 'div',
                  :class       => [:clearfix ,:field_container, :full_width],
                  :hint_class  => :field_with_hint,
                  :error_class => :error do |wrapper|

    wrapper.use :label_input
    wrapper.use :hint, :wrap_with => { :tag => :span, :class => :hint }
    #b.use :error, :wrap_with => { :tag => :span, :class => :error }
  end

  config.wrappers :non_persistence_fields,
                  :tag         => :div,
                  :class       => [:clearfix],
                  :error_class => :error do |wrapper|
    wrapper.use :label
  end
  
  config.label_class = 'control-label'
  # config.form_class = 'form-horizontal'
  config.input_class = 'form-control'
  config.browser_validations = false

end
