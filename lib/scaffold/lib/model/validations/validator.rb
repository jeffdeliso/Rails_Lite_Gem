class Validator
  attr_reader :options, :attribute

  def initialize(attribute, options = {})
    default = {
      allow_nil: false,
      presence: false,
      uniqueness: false,
      length: false,
      class: false
    }

    default.merge!(options)
    @attribute = attribute
    @options = default
  end

  def allow_nil(_obj, _val, _errors_array)
  end

  def presence(_obj, val, errors_array)
    errors_array << "#{attribute} must be present" if val.blank?
  end

  def uniqueness(obj, val, errors_array)
    if obj.id.nil?
      where_line = "#{attribute} = '#{val}'"
    else
      where_line = "#{attribute} = '#{val}' AND id != #{obj.id}"
    end
    
    arr = obj.class.where(where_line)
    errors_array << "#{attribute} must be unique" unless arr.empty?
  end

  def class(_obj, val, errors_array)
    errors_array << "#{attribute} must be #{options[:class]}" unless val.is_a?(options[:class])
  end

  def length(_obj, val, errors_array)
    if val.nil?
      errors_array << "#{attribute} can't be nil" unless options[:length][:allow_nil]

      return errors_array
    elsif options[:length].is_a?(Hash)

      min = options[:length][:minimum]
      if min && val.length < min
        errors_array << "#{attribute} must be longer than #{min} characters"
      end
      
      max = options[:length][:maximum]
      if max && val.length > max
        errors_array << "#{attribute} must be shorter than #{max} characters"
      end
    else
      unless val.length = options[:length]
        errors_array << "#{attribute} must be #{max} characters"
      end
    end

    errors_array
  end

  def valid?(obj)
    errors(obj).empty?
  end

  def errors(obj)
    errors_array = []
    val = obj.send(attribute)

    return errors_array if val.nil? && options[:allow_nil]

    options.each do |name, validate|
      self.send(name, obj, val, errors_array) if validate
    end

    errors_array
  end
end