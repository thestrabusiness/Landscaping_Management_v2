class AddDateReceivedToPayment < ActiveRecord::Migration[5.2]
  def change
    add_column :payments, :date_received, :date
  end
end
