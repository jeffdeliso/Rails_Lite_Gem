require 'erb'

class ShowExceptions
  attr_reader :app

  def initialize(app)
    @app = app

  end

  def call(env)
    begin
      app.call(env)
    rescue Exception => e
      render_exception(e)
    end
  end

  private

  def render_exception(e)
    directory = File.dirname(__FILE__)
    path = File.join(directory, "templates", "rescue.html.erb")
    view = File.read(path)
    ['500', {'Content-type' => 'text/html'}, ERB.new(view).result(binding)]
  end

end
