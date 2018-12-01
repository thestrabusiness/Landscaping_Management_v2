class Payment < ApplicationRecord
  belongs_to :client
  belongs_to :invoice

  validates :payment_type, :amount, presence: true
  validates :client, presence: true

  def amount_difference
    amount_before_last_save - amount
  end
end
