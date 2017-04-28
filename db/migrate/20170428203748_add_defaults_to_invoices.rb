class AddDefaultsToInvoices < ActiveRecord::Migration[5.0]
  def change
    change_column_default :invoices, :total, 0.0
    change_column_default :invoices, :status, 'PENDING'
  end
end
