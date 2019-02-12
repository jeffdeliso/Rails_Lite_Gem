class FlashNow
  attr_reader :hash

  def initialize(hash = {})
    @hash = hash
  end

  def [](key)
    hash[key.to_s]
  end

  def []=(key, val)
    hash[key.to_s] = val
  end
end