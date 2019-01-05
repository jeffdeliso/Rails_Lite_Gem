class Static
  attr_reader :app

  def initialize(app)
    @app = app
  end

  def call(env)
    app.call(env)
  end
end
