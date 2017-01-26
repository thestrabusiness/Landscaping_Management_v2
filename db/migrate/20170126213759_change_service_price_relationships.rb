class ChangeServicePriceRelationships < ActiveRecord::Migration[5.0]
  def change
    add_reference :service_prices, :address, index: true
  end
end
