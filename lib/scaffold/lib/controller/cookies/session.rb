require 'json'

class Session

  def initialize(req)
    cookie = req.cookies['_rails_lite_app']
    if cookie
      @cookie_data = JSON.parse(cookie)
    else
      @cookie_data = {}
    end
  end

  def [](key)
    cookie_data[key.to_s]
  end

  def []=(key, val)
    cookie_data[key.to_s] = val
  end

  def store_session(res)
    cookie = { path: '/', value: JSON.generate(cookie_data) }
    res.set_cookie('_rails_lite_app', cookie)
  end

  private
  attr_reader :cookie_data
end
