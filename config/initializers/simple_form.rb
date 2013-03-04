SimpleForm.setup do |config|

  config.wrappers :default,
                  :tag         => 'div',
                  :class       => [:clearfix ,:field_container],
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

  SimpleForm.form_class = "form-stacked"
  SimpleForm.browser_validations = false
end
