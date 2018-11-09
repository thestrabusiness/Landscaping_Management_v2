class Address < ApplicationRecord
  belongs_to :client, inverse_of: :billing_address
  has_many :invoices
  has_many :service_prices
  has_many :estimates

  validates :street, :city, :state, :zip, presence: true
  validates :client, presence: true

  before_create :assign_default_position, if: :is_job_address?
  after_create :insert_at_new_position
  after_update :reorder_addresses

  scope :billing, -> { where(billing_address: true) }
  scope :job, -> { where(billing_address: false) }

  def self.autocomplete_source
    order(:client_id).map{ |address| { label: address.full_address, id: address.id }}
  end

  def full_address
    [
        street,
        city,
        state,
        zip
    ].join(' ')
  end

  def street_city
    "#{street} - #{city}"
  end

  private

  def assign_default_position
    return if position.present?
    max_position = Address.maximum(:position)
    self.position = max_position.present? ? max_position + 1 : 1
  end

  def insert_at_new_position
   Address
       .where('position IS NOT NULL AND position >= ? AND id != ?', position, id)
       .update_all('position = position + 1')
  end

  def reorder_addresses
    return unless saved_change_to_position?

    old_position = position_before_last_save
    new_position = position

    position_difference = old_position - new_position
    shift_direction = position_difference > 0 ? 1 : -1
    range = shift_direction > 0 ? new_position...old_position : old_position..new_position

    Address
        .where('position IN (?) and id != ?', range, id)
        .update_all("position = position + #{shift_direction}")
  end
end
