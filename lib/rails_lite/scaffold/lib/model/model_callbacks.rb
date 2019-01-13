require 'active_support/concern'

module ModelCallbacks
  extend ActiveSupport::Concern

  def after_init
    names = self.class.after_init_names[self.class]
    names.each { |name| self.send(name) }
  end

  def self.included(klass)
    class << klass
      alias_method :__new, :new
      def new(*args)
        e = __new(*args)
        e.after_init
        e
      end
    end
  end
  
  def before_valid
    names = self.class.before_valid_names[self.class]
    names.each { |name| self.send(name) }
  end
  
  
  module ClassMethods
    
    def before_valid_names
      @@before_valid_names ||= Hash.new { |h, k| h[k] = [] }
    end
  
    def after_init_names
      @@after_init_names ||= Hash.new { |h, k| h[k] = [] }
    end

    def after_initialize(*names)
      after_init_names[self] += names
    end

    def before_validation(*names)
      before_valid_names[self] += names
    end
  end
end