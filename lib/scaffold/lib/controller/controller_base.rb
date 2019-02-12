require 'active_support'
require 'active_support/core_ext'
require 'erb'
require 'active_support/inflector'
require 'json'
require 'jbuilder'
require_relative './cookies/session'
require_relative './cookies/flash'
require_relative './strong_params'
require_relative './controller_callbacks'
require_relative './format'
require_relative '../utils/url_helpers'

class ControllerBase
  extend ControllerCallbacks
  include UrlHelpers

  attr_reader :req, :res, :params

  def self.protect_from_forgery
    @@protect_from_forgery = true
  end

  def initialize(req, res, route_params = {}, patterns)
    @req = req
    @res = res
    @params = StrongParams.new_syms(req.params.merge(route_params))
    @already_built_response = false
    self.class.make_helpers(patterns)
  end

  def invoke_action(name)
    if protect_from_forgery? && req.request_method != "GET"
      check_authenticity_token
    else
      form_authenticity_token
    end
    
    self.send(name)
    render name unless already_built_response?
    
    nil
  end
  
  def form_authenticity_token
    @form_authenticity_token ||= SecureRandom::urlsafe_base64
    cookie = { path: '/', value: @form_authenticity_token }
    res.set_cookie("#{@form_authenticity_token[0..5]}authenticity_token", cookie)
    @form_authenticity_token
  end
  
  def link_to(name, path)
    "<a href=\"#{path}\">#{name}</a>"
  end
  
  def root_url
    '/'
  end

  protected
  
  def redirect_to(url)
    prepare_render_or_redirect
    
    res.status = 302
    res['Location'] = url
    
    nil
  end

  def render(options)
    if options.is_a?(Symbol)
      if File.exist?(html_view_path(options))
        render_template(options)
      else
        render_json_template(options)
      end
    else
      render_json(options[:json])
    end
  end

  def respond_to(&prc)
    format = new Format(self)
    prc.call(format)
  end

  def session
    @session ||= Session.new(req)
  end
  
  def flash
    @flash ||= Flash.new(req)
  end
  
  private

  def render_json(obj)
    if obj.is_a?(Array)
      content = Jbuilder.encode do |json|
        json.array! obj
      end
    else
      # content = Jbuilder.encode do |json|
      #   json.child! obj
      # end
      content = obj.attributes.to_json
    end

    render_content(content, 'application/json')
  end

  def render_json_template(template_name)
    path = json_view_path(template_name)
    file_content = "<%= #{File.read(path)} %>"
    content = ERB.new(file_content).result(binding)

    render_content(content, 'application/json')
  end

  def render_template(template_name)
    path = html_view_path(template_name)
    content = ERB.new(File.read(path)).result(binding)
    app_content = build_content { content }

    render_content(app_content, 'text/html')
  end

  def already_built_response?
    @already_built_response
  end
  
  def render_content(content, content_type)
    prepare_render_or_redirect

    res['Content-Type'] = content_type
    res.write(content)

    nil
  end

  def prepare_render_or_redirect
    raise "double render error" if already_built_response?
    @already_built_response = true
    session.store_session(@res)
    flash.store_flash(@res)
  end

  def build_content(&prc)
    directory = File.dirname(__FILE__)
    path = File.join(
      directory, '..', '..',
      'app', 'views', "application.html.erb"
    )

    app_content = ERB.new(File.read(path)).result(binding)
  end
  
  def check_authenticity_token
    param_token = params['authenticity_token']
    cookie = req.cookies["#{param_token[0..5]}authenticity_token"]
    unless param_token && cookie == param_token
      raise 'Invalid authenticity token'
    end
  end

  def protect_from_forgery?
    @@protect_from_forgery ||= false
  end

  def json_view_path(name)
    directory = File.dirname(__FILE__)
    controller_name = self.class.to_s.underscore
    File.join(
          directory, "..", '..',
          'app', 'views', controller_name,
          "#{name}.json.jbuilder"
    )
  end

  def html_view_path(name)
    directory = File.dirname(__FILE__)
    controller_name = self.class.to_s.underscore
    File.join(
          directory, "..", '..',
          'app', 'views', controller_name,
          "#{name}.html.erb"
    )
  end
end

