class ClientPrice < ApplicationRecord
  belongs_to :client

  validates :name, :price, presence: true
  validates :client, presence: true
end
