require 'active_support'
require 'active_support/core_ext'
require 'erb'
require 'active_support/inflector'
require_relative './cookies/session'
require_relative './cookies/flash'
require_relative './strong_params'
require_relative './callbacks'

class ControllerBase
  extend Callbacks

  attr_reader :req, :res, :params

  def self.protect_from_forgery
    @@protect_from_forgery = true
  end

  def self.make_helpers(patterns)
    patterns.each do |pattern|
      url_arr = pattern.inspect.delete('\^$?<>/+()').split('\\').drop(1).reject { |el| el == "d"}

      unless url_arr.include?("id")
        helper_name = url_arr.reverse.join("_")
        helper_name += "_url"
        url = url_arr.join("/")
        url = "/" + url
        define_method(helper_name) do
          url
        end
      else
        name_arr = url_arr.dup
        name_arr[0] = url_arr.first.singularize
        helper_name = name_arr.reject { |el| el == "id"}.reverse.join("_")
        helper_name += "_url"

        define_method(helper_name) do |id|
          obj_id = id.try(:id)
          url = url_arr.map do |el|
            if el == "id"
              "#{obj_id || id}"
            else
              el
            end
          end
          
          "/" + url.join("/")
        end
      end
    end
  end

  # Setup the controller
  def initialize(req, res, route_params = {}, patterns)
    @req = req
    @res = res
    @params = StrongParams.new_syms(req.params.merge(route_params))
    @already_built_response = false
    self.class.make_helpers(patterns)
  end

  # use this with the router to call action_name (:index, :show, :create...)
  def invoke_action(name)
    if protect_from_forgery? && req.request_method != "GET"
      check_authenticity_token
    else
      form_authenticity_token
    end
    
    self.send(name)
    render name unless already_built_response?
  end
  
  def form_authenticity_token
    @form_authenticity_token ||= SecureRandom::urlsafe_base64
    cookie = { path: '/', value: @form_authenticity_token }
    res.set_cookie('authenticity_token', cookie)
    @form_authenticity_token
  end

  def link_to(name, path)
    "<a href=\"#{path}\">#{name}</a>"
  end
  
  protected

  def redirect_to(url)
    unless @already_built_response
      @already_built_response = true
      res.status = 302
      res['Location'] = url
      session.store_session(res)
      flash.store_flash(res)
    else
      raise "Can't render/redirect more than once"
    end
  end
  
  # use ERB and binding to evaluate templates
  # pass the rendered html to render_content
  def render(template_name)
    directory = File.dirname(__FILE__)
    controller_name = self.class.to_s.underscore
    path = File.join(directory, "..", '..', 'app', 'views', controller_name, "#{template_name}.html.erb")
    content = ERB.new(File.read(path)).result(binding)
    render_content(content, 'text/html')
  end
 
  def session
    @session ||= Session.new(req)
  end
  
  def flash
    @flash ||= Flash.new(req)
  end
  
  private
  # Helper method to alias @already_built_response
  def already_built_response?
    @already_built_response
  end
  
  # Populate the response with content.
  # Set the response's content type to the given type.
  # Raise an error if the developer tries to double render.
  def render_content(content, content_type)
    unless already_built_response?
      @already_built_response = true
      res['Content-Type'] = content_type
      app_content = build_content { content }
      res.write(app_content)
      session.store_session(res)
      flash.store_flash(res)
    else
      raise "Can't render/redirect more than once"
    end
  end

  def build_content(&prc)
    directory = File.dirname(__FILE__)
    path = File.join(directory, '..', '..', 'app', 'views', "application.html.erb")
    app_content = ERB.new(File.read(path)).result(binding)
  end
  
  def check_authenticity_token
    unless params['authenticity_token'] && req.cookies['authenticity_token'] == params['authenticity_token'] 
      raise 'Invalid authenticity token'
    end
  end

  def protect_from_forgery?
    @@protect_from_forgery ||= false
  end
end

