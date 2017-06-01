class EstimateItem < ActiveRecord::Base
  belongs_to :estimate

  def total
    price * quantity
  end
end
