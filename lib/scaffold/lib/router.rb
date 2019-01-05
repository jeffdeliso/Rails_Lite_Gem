class Route
  attr_reader :pattern, :http_method, :controller_class, :action_name

  def initialize(pattern, http_method, controller_class, action_name)
    @pattern, @http_method, @controller_class, @action_name = pattern, http_method, controller_class, action_name
  end

  # checks if pattern matches path and method matches request method
  def matches?(req)
    method = req.params['_method'] || req.request_method
    pattern =~ req.path && http_method.to_s == method.downcase
  end

  # use pattern to pull out route params (save for later?)
  # instantiate controller and call controller action
  def run(req, res, patterns)
    route_params = {}
    match_data = pattern.match(req.path)
    match_data.names.each do |key|
      route_params[key] = match_data[key]
    end
    
    controller = controller_class.new(req, res, route_params, patterns)
    controller.invoke_action(action_name)
  end
end

class Router
  attr_reader :routes, :patterns

  def initialize
    @routes = []
    @patterns = []
  end

  # simply adds a new route to the list of routes
  def add_route(pattern, method, controller_class, action_name)
    routes << Route.new(pattern, method, controller_class, action_name)
    patterns << pattern unless patterns.include?(pattern)
  end

  # evaluate the proc in the context of the instance
  # for syntactic sugar :)
  def draw(&proc)
    self.instance_eval(&proc)
  end

  # make each of these methods that
  # when called add route
  [:get, :post, :patch, :delete, :put].each do |http_method|
    define_method(http_method) do |pattern, controller_class, action_name|
      add_route(pattern, http_method, controller_class, action_name)
    end
  end

  # should return the route that matches this request
  def match(req)
    routes.find { |route| route.matches?(req) }
  end

  # either throw 404 or call run on a matched route
  def run(req, res)
    route = match(req)
    if route
      route.run(req, res, patterns)
    else
      res.status = 404
      res.write('Route not found')
    end
  end
  
end
