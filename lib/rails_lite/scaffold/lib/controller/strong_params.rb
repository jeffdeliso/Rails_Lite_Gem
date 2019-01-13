class StrongParams
  attr_reader :params
  
  def self.to_sym(hash)
    sym_hash = {}
    hash.each do |key, val|
      sym_hash[key.to_sym] = (val.is_a?(Hash) ? to_sym(val) : val)
    end

    sym_hash
  end

  def self.new_syms(params)
    StrongParams.new(StrongParams.to_sym(params))
  end

  def initialize(params)
    @params = params
  end
  
  def require(class_name)
    StrongParams.new(params[class_name])
  end

  def permit(*keys)
    permited_params = {}
    keys.each { |key| permited_params[key] = params[key] }
    permited_params
  end

  def [](key)
    params[key.to_sym]
  end

  private

  def []=(key, val)
    params[key.to_sym] = val
  end
end