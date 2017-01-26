class Address < ApplicationRecord
  belongs_to :client
  has_many :client_prices

  validates :street, :city, :state, :zip, presence: true
  validates :client, presence: true
end
