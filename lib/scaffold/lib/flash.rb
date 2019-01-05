require 'json'

class Flash
  attr_reader :now

  def initialize(req)
    cookie = req.cookies['_rails_lite_app_flash']
    if cookie
      @now = FlashNow.new(JSON.parse(cookie))
    else
      @now = FlashNow.new
    end
    @cookie_data = {}
  end

  def [](key)
    now[key.to_s] || cookie_data[key.to_s]
  end

  def []=(key, val)
    cookie_data[key.to_s] = val
  end
  
  # serialize the hash into json and save in a cookie
  # add to the responses cookies
  def store_flash(res)
    cookie = { path: '/', value: JSON.generate(cookie_data) }
    res.set_cookie('_rails_lite_app_flash', cookie)
  end

  private
  attr_reader :cookie_data
end

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
