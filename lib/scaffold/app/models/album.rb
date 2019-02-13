class Album < ApplicationModel
  belongs_to :band
  has_many :tracks
  
  validates :band, presence: true
  validates :name, presence: true
  validates :year, presence: true

  after_initialize :set_defaults

  def set_defaults
    self.live ||= false
  end
end