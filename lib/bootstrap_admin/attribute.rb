module BootstrapAdmin

  # BootstrapAdmin::Attribute represents a model attribute and stores
  # its name, human_name and a computed "type" which can be one of:
  #  * :association
  #  * :attribute
  #  * :none
  # (take a look at active_record_extensions)
  # This is used to build UI elements (see: app/views/defaults/_[show|form|index])

  Attribute = Struct.new :name, :human_name, :type
  Attribute.class_eval do
    def to_s; name; end
    def to_sym; to_s.to_sym; end
    def association?; :association == type; end
    def attribute?; :attribute == type; end
  end
end
