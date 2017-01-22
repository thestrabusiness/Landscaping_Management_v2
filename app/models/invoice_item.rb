class InvoiceItem < ApplicationRecord
  belongs_to :invoice

  validates :name, :price, :quantity, presence: true
  validates :invoice, presence: true
end
