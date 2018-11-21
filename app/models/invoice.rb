class Invoice < ApplicationRecord
  belongs_to :client
  belongs_to :job_address, class_name: 'Address'
  has_many :payments
  has_many :invoice_items

  time_for_a_boolean :deleted

  validates :total, :performed_by, :job_date, presence: true
  validates :client, presence: true

  def self.autocomplete_source
    includes(:client, :job_address).order(:client_id).map{ |invoice| { label: invoice.summary, id: invoice.id }}
  end

  def summary
    [client.full_name, job_address.street, total].join(' - ')
  end

  def job
    job_address
  end

  def check_balance_forward
    if client.balance == 0
      'zero-balance'
    elsif client.balance - total < 0
      'payment-received'
    else
      'positive-balance'
    end
  end

  def balance_forward
    if client.balance == 0
      0
    else
      (client.balance - total)
    end
  end

  def amount_due
    total + balance_forward
  end
end
