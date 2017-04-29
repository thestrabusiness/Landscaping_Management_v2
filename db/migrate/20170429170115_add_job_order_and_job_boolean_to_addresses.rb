class AddJobOrderAndJobBooleanToAddresses < ActiveRecord::Migration[5.0]
  def change
    add_column :addresses, :job_order, :integer
    add_column :addresses, :job_address, :boolean, default: true
  end
end
