module BootstrapAdmin

  # BootstrapAdmin::Attribute represents a model attribute and stores
  # its name, human_name and a computed "type" which can be one of:
  #  :association
  #  :attribute
  #  :none
  # (take a look at active_record_extensions).
  #
  # This is used to build UI elements, see:
  #   app/views/defaults/show
  #   app/views/defaults/form
  #   app/views/defaults/index

  class Attribute
    attr_reader :name, :human_name, :type

    def initialize name, human_name, type
      @name, @human_name, @type = name, human_name, type
    end

    # @return [String] the attribute's name
    def to_s; name.to_s; end

    # @return [Symbol] the attribute's name, but as a Symbol
    def to_sym; to_s.to_sym; end

    # @return [true, false] true if type is :association, false otherwise
    def association?; :association == type; end

    # @return [true, false] true if type is :attribute, false otherwise
    def attribute?; :attribute == type; end
  end
end
