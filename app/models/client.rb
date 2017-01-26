class Client < ApplicationRecord
  has_many :service_prices
  has_many :invoices
  has_many :payments
  has_many :addresses
  has_one :billing_address, class_name: 'Address'

  accepts_nested_attributes_for :addresses

  time_for_a_boolean :deleted

  validates :first_name, :last_name, :phone_number, presence: true

  def self.default_scope
    where(deleted_at: nil)
  end

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

