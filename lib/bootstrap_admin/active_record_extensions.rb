# -----------------------------------------------------------------------------
# => TODO: This looks like a monkeypatch.. make this "the right way"..
ActiveRecord::Base.class_eval do
  def self.type_of name
    name = name.to_sym
    associations = self.reflect_on_all_associations.map(&:name)
    if name.match(/(.*)_id(s)?$/) and associations.include? "#{$1}#{$2}"
      :association
    elsif associations.include? name
      :association
    elsif self.attribute_names.include? name.to_s
      :attribute
    else
      :none
    end
  end
end
