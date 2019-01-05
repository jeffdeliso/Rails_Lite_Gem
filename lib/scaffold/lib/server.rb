#!/usr/bin/env ruby
require 'rack'
require_relative './router'
require_relative './routes'
require_relative '../models/application_model'
require_relative '../models/cat'
require_relative '../models/user'
require_relative '../models/house'
require_relative '../controllers/application_controller'
require_relative '../controllers/cats_controller'
require_relative '../controllers/users_controller'
require_relative '../controllers/sessions_controller'
# require_relative '../controllers/houses_controller'

router = Router.new
create_routes(router)
# router.draw do
#   get Regexp.new("^/?$"), CatsController, :index
#   get Regexp.new("^/cats/?$"), CatsController, :index
#   get Regexp.new("^/cats/new/?$"), CatsController, :new
#   get Regexp.new("^/cats/(?<id>\\d+)/?$"), CatsController, :show
#   post Regexp.new("^/cats$"), CatsController, :create
#   delete Regexp.new("^/cats/(?<id>\\d+)/?$"), CatsController, :destroy
#   patch Regexp.new("^/cats/(?<id>\\d+)/?$"), CatsController, :update
#   get Regexp.new("^/cats/(?<id>\\d+)/edit/?$"), CatsController, :edit

#   get Regexp.new("^/users/?$"), UsersController, :index
#   get Regexp.new("^/users/(?<id>\\d+)/?$"), UsersController, :show
#   get Regexp.new("^/users/new/?$"), UsersController, :new
#   post Regexp.new("^/users/?$"), UsersController, :create
#   delete Regexp.new("^/users/(?<id>\\d+)/?$"), UsersController, :destroy

#   get Regexp.new("^/sessions/new/?$"), SessionsController, :new
#   post Regexp.new("^/sessions/?$"), SessionsController, :create
#   delete Regexp.new("^/sessions/?$"), SessionsController, :destroy
# end

app = Proc.new do |env|
  req = Rack::Request.new(env)
  res = Rack::Response.new
  router.run(req, res)
  res.finish
end

Rack::Server.start(
 app: app,
 Port: 3000
)