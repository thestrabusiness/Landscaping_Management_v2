class Client < ApplicationRecord
  has_many :service_prices
  has_many :invoices
  has_many :payments
  has_many :addresses
  has_many :job_addresses, -> { where(billing_address: false) }, class_name: 'Address'
  has_many :estimates, through: :addresses
  belongs_to :billing_address, class_name: 'Address'

  accepts_nested_attributes_for :addresses

  time_for_a_boolean :deleted

  validates :first_name, :last_name, :phone_number, presence: true

  def self.default_scope
    where(deleted_at: nil)
  end

  def self.search(query)
    joins(:addresses).
        where("first_name ilike :query or
              last_name ilike :query or
              addresses.street ilike :query or
              addresses.city ilike :query or
              addresses.zip ilike :query or
              concat_ws(' ',first_name, last_name) ilike :query",
                           query: "%#{query}%")
  end

  def self.autocomplete_source
    all.map{ |client| { label: client.summary, id: client.id }}
  end

  def summary
    [full_name, full_billing_address].join(' - ')
  end

  def full_name
    [first_name, last_name].join(' ')
  end

  def full_billing_address
    [
        billing_address.street,
        billing_address.city,
        billing_address.state,
        billing_address.zip
    ].join(' ')
  end

  def underscore_name
    [first_name, last_name].join('_').downcase
  end

  def recent_invoices(limit = 5)
    invoices.order(created_at: :desc).limit(limit)
  end

  def recent_payments(limit = 5)
    payments.order(created_at: :desc).limit(limit)
  end

  def last_payment
    payment = Payment.where(client_id: id).scoping { Payment.last }

    payment.present? ? payment.amount : nil
  end
end

