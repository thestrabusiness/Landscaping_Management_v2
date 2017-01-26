class RenameClientPricesToServicePrices < ActiveRecord::Migration[5.0]
  def change
    rename_table :client_prices, :service_prices
  end
end
