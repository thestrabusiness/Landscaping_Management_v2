class Estimate < ActiveRecord::Base
  has_many :estimate_items

  time_for_a_boolean :deleted
end
