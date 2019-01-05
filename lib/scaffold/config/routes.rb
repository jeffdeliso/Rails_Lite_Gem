def create_routes(router)
  router.draw do
    get Regexp.new("^/?$"), CatsController, :index
    get Regexp.new("^/cats/?$"), CatsController, :index
    get Regexp.new("^/cats/new/?$"), CatsController, :new
    get Regexp.new("^/cats/(?<id>\\d+)/?$"), CatsController, :show
    post Regexp.new("^/cats$"), CatsController, :create
    delete Regexp.new("^/cats/(?<id>\\d+)/?$"), CatsController, :destroy
    patch Regexp.new("^/cats/(?<id>\\d+)/?$"), CatsController, :update
    get Regexp.new("^/cats/(?<id>\\d+)/edit/?$"), CatsController, :edit

    get Regexp.new("^/users/?$"), UsersController, :index
    get Regexp.new("^/users/(?<id>\\d+)/?$"), UsersController, :show
    get Regexp.new("^/users/new/?$"), UsersController, :new
    post Regexp.new("^/users/?$"), UsersController, :create
    delete Regexp.new("^/users/(?<id>\\d+)/?$"), UsersController, :destroy

    get Regexp.new("^/sessions/new/?$"), SessionsController, :new
    post Regexp.new("^/sessions/?$"), SessionsController, :create
    delete Regexp.new("^/sessions/?$"), SessionsController, :destroy
  end
end