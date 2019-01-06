require_relative 'assoc_options'

class BelongsToOptions < AssocOptions

  def initialize(name, options = {})
    default = {
      foreign_key: "#{name}_id".to_sym,
      class_name: name.to_s.capitalize, 
      primary_key: :id,
      optional: false
    }

    default.merge!(options)
    @foreign_key = default[:foreign_key]
    @class_name = default[:class_name]
    @primary_key = default[:primary_key]
  end
  
end