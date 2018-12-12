class Payment < ApplicationRecord
  belongs_to :client
  belongs_to :invoice, optional: true

  validates :payment_type, :amount, presence: true
  validates :client, presence: true

  time_for_a_boolean :deleted

  default_scope -> { where(deleted_at: nil) }

  def amount_difference
    amount_before_last_save - amount
  end
end
