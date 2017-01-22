class Address < ApplicationRecord
  belongs_to :client

  validates :street, :city, :state, :zip, presence: true
  validates :client, presence: true
end
