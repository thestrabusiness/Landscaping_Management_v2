class EstimateItem < ActiveRecord::Base
  belongs_to :estimate

  with_options presence: true do |model|
    model.validates :price
    model.validates :quantity
    model.validates :estimate
    model.validates :description
  end

  def total
    price * quantity
  end
end
