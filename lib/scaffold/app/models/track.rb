class Track < ApplicationModel

  validates :lyrics, presence: true
  validates :name, presence: true
  validates :ord, presence: true

  belongs_to :album

  has_one :band,
    through: :album,
    source: :band

  has_many :notes

  after_initialize :set_defaults

  def set_defaults
    self.bonus ||= false
  end
end