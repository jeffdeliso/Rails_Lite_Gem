# require_relative '../lib/sql_object'

class Band < ApplicationModel
  validates :name, presence: true, uniqueness: true

  has_many :albums
end 