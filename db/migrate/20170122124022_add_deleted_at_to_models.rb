class AddDeletedAtToModels < ActiveRecord::Migration[5.0]
  def change
    add_column :clients, :deleted_at, :datetime
    add_column :invoices, :deleted_at, :datetime
    add_column :payments, :deleted_at, :datetime
  end
end
