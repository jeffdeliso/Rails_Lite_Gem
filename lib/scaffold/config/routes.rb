def create_routes(router)
  router.draw do
    get Regexp.new("^/?$"), UsersController, :new
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
