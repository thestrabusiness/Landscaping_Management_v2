class Estimate < ActiveRecord::Base
  has_many :estimate_items
  belongs_to :address
  has_one :client, through: :address

  time_for_a_boolean :deleted
end
