class AddJobOrderAndJobBooleanToAddresses < ActiveRecord::Migration[5.0]
  def change
    add_column :addresses, :position, :integer
    add_column :addresses, :is_job_address?, :boolean, default: true
  end
end
