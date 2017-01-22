class CreateInvoices < ActiveRecord::Migration[5.0]
  def change
    create_table :invoices do |t|
      t.references :client
      t.money :total
      t.datetime :job_date
      t.string :performed_by
      t.string :notes
      t.string :status

      t.timestamps
    end
  end
end
