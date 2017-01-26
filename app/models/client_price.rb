class ClientPrice < ApplicationRecord
  belongs_to :address
  belongs_to :client

  validates :name, :price, presence: true
end
