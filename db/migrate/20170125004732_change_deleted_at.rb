class ChangeDeletedAt < ActiveRecord::Migration[5.0]
  def change
    change_column :clients, :deleted_at, :timestamp
  end
end
