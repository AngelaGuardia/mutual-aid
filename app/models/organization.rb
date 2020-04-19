class Organization < ApplicationRecord
  has_many :external_resources
  has_many :positions

  validates :name, presence: true

  def primary_contact
    positions.find_by(is_primary: true)
  end
end
