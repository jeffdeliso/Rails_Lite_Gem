# RailsLite

RailsLite is a MVC framework for building web applications. Some features include:

* SQLite or PostgreSQL ORM with associations and search
* Controllers with Session and Flash Management
* CSRF Protetion
* Static Asset Rendering
* RESTful and Custom Routing
* URL Helper Methods
* Server
* Model Validations
* Model and Controller Lifecycle Methods
* JBuilder and HTML Views

For an example, visit: [https://github.com/jeffdeliso/rails_lite_sample_app](https://github.com/jeffdeliso/rails_lite_sample_app)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rails_lite'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rails_lite

## Usage

### Creating a Project

To create a new project navigate the directory you would like to create the project and run:

    $ railslite new [PROJECT_NAME]
    
To start a local server run either:

    $ railslite server
    $ railslite s
    
To open pry for your project run either:

    $ railslite console
    $ railslite c

### Database

RailsLite's ORM works with SQLite, so you will need to edit the `db/database.sql` file to reflect your schema and include your seeds. Then run:

    $ railslite dbreset

### Routes

Routes go in the `config/routes.rb` file. Routes work exactly like they do in rails. 

```ruby
root to: 'bands#index'

resource :sessions, only: [:new, :create, :destroy]

resources :users, only: [:show, :new, :create] do
  member do 
    get :[CUSTOM_ROUTE]
  end
end

resources :bands do
  collection do
    get :[CUSTOM_ROUTE]
  end
  resources :albums, only: [:new]
end

resources :albums, except: [:index, :new] do
  resources :tracks, only: [:new]
end

resources :tracks, only: [:show, :create, :edit, :update, :destroy,]

resources :notes, only: [:create, :destroy]
patch '/[CUSTOM_ROUTE]/:id', to: 'notes#[CUSTOM_METHOD]'
get '/[CUSTOM_ROUTE]', to: 'notes#[CUSTOM_METHOD]'
```

URL helper methods are created for your routes. To view these methods and all of your routes run:

    $ railslite routes
    
### Models

Models go in `app/models` and inherit from ApplicationModel.  You can add methods to ApplicationModel at `app/models/application_model.rb`. Models have access to validations on presence, uniqueness and length, as well as, the lifecyle methods `after_initialize` and `before_validation`. Models also can have `belongs_to`, `has_many` and `has_one` using the same syntax as rails. Creating a `belongs_to` association will automatically create a validation for the presence of the `foreign_key` unless `optional: true` is included.

```ruby
require 'bcrypt'

class User < ApplicationModel
  validates :username, presence: true, uniqueness: true
  validates :password_digest, presence: true
  validates :password, length: { minimum: 6, allow_nil: true }
  validates :session_token, presence: true, uniqueness: true

  has_many :notes

  after_initialize :ensure_token
  
  attr_reader :password
  
  def self.find_by_credentials(username, password)
    user = User.find_by(username: username)
    user && user.is_password?(password) ? user : nil
  end
  
  def self.generate_token
    SecureRandom::urlsafe_base64
  end
  
  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end
  
  def ensure_token
    self.session_token ||= User.generate_token
  end
  
  def reset_token!
    self.session_token = User.generate_token
    self.save!
    self.session_token
  end
  
  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end
end
```

### Controllers

Models go in `app/controllers` and inherit from ApplicationController. You can add methods to ApplicationController at `app/controllers/application_model.rb`. Contoller methods will automatically render their corrosponding view if no render or redirect is specified. Controllers also support strong params and have a `before_action` lifecycle method. Including `protect_from_forgery` in a controller will implement CSRF protection. Include `<input type="hidden" name="authenticity_token" value="<%= form_authenticity_token %>">` in any of your forms when `protect_from_forgery` is enabled.

```ruby
class BandsController < ApplicationController
  protect_from_forgery
  
  def index
    @bands = Band.all
  end

  def show
    @band = Band.find(params[:id])
  end

  def new
    @band = Band.new
  end

  def create
    @band = Band.new(band_params)

    if @band.save
      redirect_to band_url(@band)
    else
      flash.now[:errors] = @band.errors
      render :new
    end
  end

  def edit
    @band = Band.find(params[:id])
  end

  def update
    @band = Band.find(params[:id])
    if @band.update_attributes(band_params)
      redirect_to band_url(@band)
    else
      flash.now[:errors] = @band.errors
      render :edit
    end
  end

  def destroy
    @band = Band.find(params[:id])
    @band.destroy
    redirect_to bands_url
  end

  def json
    @bands = Band.all
  end

  private
  
  def band_params
    params.require(:band).permit(:name)
  end

  before_action :ensure_login
end

```

### Views

Create your views at `app/views/[CONTROLLER_NAME]/[ACTION].html.erb` or `app/views/[CONTROLLER_NAME]/[ACTION].json.jbuilder`. Place any code you want shared between all your HTML views in `app/views/application.html.erb`.

```ruby
<h1 class='page-header'>Bands</h1>

<ul class='main-list'>
  <% @bands.each do |band| %>
    <li><a href="<%= band_url(band) %>"><p><%= band.name %></p></a></li>
  <% end %>
</ul>

<h4 class='sub-header'>Links</h4>
<ul class='page-links'>
  <li><a class='button' href="<%= new_bands_url %>" >New band</a></li>
</ul>
```
```ruby
Jbuilder.encode do |json|
  json.array! @bands
end
```

### Relation

RailsLite includes a `Relation` class that searches the database with SQL queiries similar to active record.  The Relation methods include:

* `where`
* `joins`
* `left_joins`
* `select`
* `find_by`
* `find`
* `first`
* `last`
* `all`
* `save`
* `save!`
* `update`
* `update_attributes`
* `destroy`

Relation methods are lazy and stackable.  For example:

```ruby
User.joins(:bands).where(band_id: 1)
```


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/rails_lite.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
