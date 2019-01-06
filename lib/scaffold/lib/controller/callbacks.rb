module Callbacks
  METHODS = [:index, :create, :new, :edit, :update, :show, :destroy]

  def before_action(method, options = { only: METHODS, except: [] })
  default = { only: METHODS, except: [] }
  default.merge!(options)

    names = default[:only] - default[:except]
    names.each do |name|
      m = instance_method(name)
      define_method(name) do
        
        m.bind(self).call unless send(method)
      end
    end
  end
end