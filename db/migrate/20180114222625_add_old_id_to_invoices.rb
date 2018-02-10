class AddOldIdToInvoices < ActiveRecord::Migration[5.0]
  def change
    add_column :invoices, :old_id, :integer, index: true
    add_index :clients, :old_id
  end
end
