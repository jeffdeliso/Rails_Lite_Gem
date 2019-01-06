require 'json'

class Session
  # find the cookie for this app
  # deserialize the cookie into a hash
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

  # serialize the hash into json and save in a cookie
  # add to the responses cookies
  def store_session(res)
    cookie = { path: '/', value: JSON.generate(cookie_data) }
    res.set_cookie('_rails_lite_app', cookie)
  end

  private
  attr_reader :cookie_data
end
