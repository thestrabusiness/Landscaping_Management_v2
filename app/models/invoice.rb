class Invoice < ApplicationRecord
  belongs_to :client
  belongs_to :job_address, class_name: 'Address'
  has_many :payments
  has_many :invoice_items

  time_for_a_boolean :deleted

  # validates :total, :performed_by, :job_date, presence: true
  validates :client, presence: true

  def job
    job_address
  end
end
