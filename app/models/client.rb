class Client < ApplicationRecord
  has_many :client_prices
  has_many :invoices
  has_many :payments
  has_many :addresses
  has_one :billing_address, class_name: 'Address'

  accepts_nested_attributes_for :addresses

  validates :first_name, :last_name, :phone_number, presence: true

end

