class Invoice < ApplicationRecord
  belongs_to :client
  has_many :payments
  has_many :invoice_items

  validates :total, :performed_by, :job_date, presence: true
  validates :client, presence: true
end
