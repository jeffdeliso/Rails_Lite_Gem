class Album < ApplicationModel
  belongs_to :band
  has_many :tracks
  
  validates :band, presence: true
  validates :name, presence: true
  validates :year, presence: true
  # can't use presence validation with boolean field
  # validates :live, inclusion: { in: [true, false] }
  # validates :name, uniqueness: { scope: :band_id }
  # validates :year, numericality: { minimum: 1900, maximum: 9000 }

  after_initialize :set_defaults

  def set_defaults
    self.live ||= false
  end
end