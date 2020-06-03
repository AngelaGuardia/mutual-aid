class Person < ApplicationRecord
  acts_as_taggable_on :tags

  belongs_to :user, optional: true, inverse_of: :person
  belongs_to :service_area, optional: true
  belongs_to :location, optional: true
  belongs_to :preferred_contact_method, class_name: 'ContactMethod', foreign_key: :preferred_contact_method_id, inverse_of: :people

  has_many :asks, inverse_of: :person
  has_many :offers, inverse_of: :person
  has_many :listings
  has_many :matches, through: :listings
  has_many :matches_as_receiver, through: :asks, class_name: "Match", foreign_key: "receiver_id"
  has_many :matches_as_provider, through: :offers, class_name: "Match", foreign_key: "provider_id"

  has_many :communication_logs
  has_many :donations
  has_many :positions
  has_many :submissions

  accepts_nested_attributes_for :location

  validate :preferred_contact_method_present!

  def name_and_email
    "#{name} (#{email})"
  end

  def preferred_contact_info
    public_send(preferred_contact_method.field)
  end

  def profile_photo(fest_code)
    "missing.png"
  end

  def match_history
    "#{asks.matched.length}/#{asks.length} asks matched, #{offers.matched.length}/#{offers.length} offers matched"
  end

  def all_tags_unique
    all_tags_list.flatten.map(&:downcase).uniq
  end

  def all_tags_to_s
    all_tags_unique.join(", ")
  end

  def ask_tag_list
    asks.any? ? asks&.map(&:all_tags_unique) : []
  end

  def offer_tag_list
    offers.any? ? offers&.map(&:all_tags_unique) : []
  end

  private def preferred_contact_method_present!
    return unless preferred_contact_method
    field = preferred_contact_method.field
    errors.add(field, :blank) if self[field].blank?
  end
end
