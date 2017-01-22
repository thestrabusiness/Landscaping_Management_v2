class Invoice < ApplicationRecord
  belongs_to :client
  has_many :payments
  has_many :invoice_items
  has_many :addresses, through: :clients
end
