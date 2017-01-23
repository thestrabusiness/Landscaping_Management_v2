class Client < ApplicationRecord
  has_many :client_prices
  has_many :invoices
  has_many :payments
  has_many :addresses
  has_one :billing_address, class_name: 'Address'

  accepts_nested_attributes_for :addresses

  validates :first_name, :last_name, :phone_number, presence: true

  def full_name
    [first_name, last_name].each{ |x| x.strip!}.join(' ')
  end

  def full_billing_address
    [
        billing_address.street,
        billing_address.city,
        billing_address.state,
        billing_address.zip
    ].join(' ')
  end

end

