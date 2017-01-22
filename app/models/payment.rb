class Payment < ApplicationRecord
  belongs_to :client
  belongs_to :invoice

  validates :payment_type, :amount, presence: true
  validates :client, presence: true
  validates :invoice, presence: true
end
