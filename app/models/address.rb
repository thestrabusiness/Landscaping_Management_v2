class Address < ApplicationRecord
  belongs_to :client
  has_many :invoices
  has_many :service_prices

  validates :street, :city, :state, :zip, presence: true
  validates :client, presence: true

  before_create :assign_position, if: Proc.new { |address| address.is_job_address? }

  #acts_as_list gem takes care of ordering job order
  acts_as_list add_new_at: :nil

  def self.job_addresses
    where(billing_address: false)
  end

  def self.autocomplete_source
    order(:client_id).map{ |address| { label: address.full_address, id: address.id }}
  end

  def assign_position
    max_position = Address.maximum(:position)

    if max_position.present?
      self.position = max_position + 1
    else
      self.position = 1
    end
  end

  def full_address
    [
        street,
        city,
        state,
        zip
    ].join(' ')
  end

end
