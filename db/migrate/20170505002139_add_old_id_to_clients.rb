class AddOldIdToClients < ActiveRecord::Migration[5.0]
  def change
    add_column :clients, :old_id, :integer
  end
end
