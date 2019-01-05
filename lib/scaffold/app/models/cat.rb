# require_relative '../lib/sql_object'

class Cat < ApplicationModel
  validates :name, presence: true, class: String, uniqueness: true

  belongs_to :owner,
    class_name: :User
    
  has_one :house,
    through: :owner,
    source: :house
end 