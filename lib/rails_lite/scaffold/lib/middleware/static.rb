require_relative 'file_server'

class Static
  attr_reader :app, :root, :file_server
  
  def initialize(app)
    @app = app
    @root = :public
    @file_server = FileServer.new(root)
  end

  def call(env)
    req = Rack::Request.new(env)
    path = req.path

    if can_serve?(path)
      res = file_server.call(env)
    else
      res = app.call(env)
    end

    res
  end

  private

  def can_serve?(path)
    path.index("/#{root}")
  end
end

