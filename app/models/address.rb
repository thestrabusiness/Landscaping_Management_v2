class Address < ApplicationRecord
  belongs_to :client
  has_many :invoices
  has_many :service_prices

  validates :street, :city, :state, :zip, presence: true
  validates :client, presence: true

  def full_address
    [
        street,
        city,
        state,
        zip
    ].join(' ')
  end

  def self.autocomplete_source
    order(:client_id).map{ |address| { label: address.full_address, id: address.id }}
  end
end
