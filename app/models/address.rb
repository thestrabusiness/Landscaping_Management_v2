class Address < ApplicationRecord
  belongs_to :client
  has_many :invoices
  has_many :service_prices

  validates :street, :city, :state, :zip, presence: true
  validates :client, presence: true

  before_create :increment_job_order, if: Proc.new { |address| address.job_address}
  after_commit :update_job_order

  def self.job_addresses
    where(billing_address: false)
  end

  def self.autocomplete_source
    order(:client_id).map{ |address| { label: address.full_address, id: address.id }}
  end

  def increment_job_order
    last_job = Address.maximum(:job_order)
    if last_job.present?
      self.job_order = last_job.to_i + 1
    else
      self.job_order = 1
    end
  end

  def update_job_order
    if previous_changes[:job_order].present?
      old_job_order = previous_changes[:job_order][0]
      new_job_order = previous_changes[:job_order][1]

      if new_job_order > old_job_order
        changing_addresses = Address.job_addresses.where('job_order > ? AND job_order < ?', old_job_order, new_job_order)
        changing_addresses.each do |address|
          address.update_attribute(:job_order, address.job_order + 1 )
        end
      else
        changing_addresses = Address.job_addresses.where('job_order > ? AND job_order < ?', new_job_order, old_job_order)
        changing_addresses.each do |address|
          address.update_attribute(:job_order, address.job_order - 1 )
        end
      end
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
