class Route
  attr_reader :pattern, :http_method, :controller_class, :action_name

  def initialize(pattern, http_method, controller_class, action_name)
    @pattern, @http_method, @controller_class, @action_name = pattern, http_method, controller_class, action_name
  end

  def matches?(req)
    method = req.params['_method'] || req.request_method
    pattern =~ req.path && http_method.to_s == method.downcase
  end

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
