class Estimate < ActiveRecord::Base
  has_many :estimate_items
  belongs_to :address
  has_one :client, through: :address

  time_for_a_boolean :deleted

  with_options presence: true do |model|
    model.validates :address
    model.validates :client
    model.validates :date
    model.validates :total
  end
end
