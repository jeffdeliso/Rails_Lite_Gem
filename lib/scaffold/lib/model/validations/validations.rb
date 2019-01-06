require 'active_support/concern'
require_relative 'validator'

module Validations
  extend ActiveSupport::Concern

  def valid?
    before_valid
    self.class.validators.all? { |validator| validator.valid?(self) }
  end

  def errors
    errors_array = []
    self.class.validators.each do |validator|
      errors_array += validator.errors(self)
    end
    
    errors_array
  end

  module ClassMethods
  
    def validators
      @validators ||= []
    end
    
    def validates(attribute, options = {})
      validators << Validator.new(attribute, options)
    end

  end
end
