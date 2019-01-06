require_relative 'assoc_options'

class HasManyOptions < AssocOptions

  def initialize(name, self_class_name, options = {})
    default = {
      foreign_key: "#{self_class_name.downcase}_id".to_sym,
      class_name: name.to_s.capitalize.singularize,
      primary_key: :id
    }

    default.merge!(options)
    @foreign_key = default[:foreign_key]
    @class_name = default[:class_name]
    @primary_key = default[:primary_key]
  end

end