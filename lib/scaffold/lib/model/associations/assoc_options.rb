class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key,
    :optional
  )

  def model_class
    class_name.to_s.constantize
  end

  def table_name
    model_class.table_name
  end
end