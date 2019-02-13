# RailsLite

RailsLite is an MVC framework for building web applications. Some features include:

* SQLite or PostgreSQL ORM with associations and search
* Controllers with Session and Flash Management
* CSRF Protetion
* Static Asset Rendering
* Restful and Custom Routing
* URL Helper Methods
* Server
* Model Validations
* Model and Controller Callbacks
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

### Models

Models go in `app/models` and inherit from ApplicationModel.  You can add methods to ApplicationModel at `app/models/application_model.rb`. Models have access to validations on presence, uniqueness and length, as well as, the lifecyle methods `after_initialize` and `before_validation`. Models also can have `belongs_to`, `has_many` and `has_one` using the same syntax as rails.

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

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/rails_lite.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
