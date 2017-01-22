class AddIndextoClients < ActiveRecord::Migration[5.0]
  def change
    add_index(:clients, :id)
  end
end
