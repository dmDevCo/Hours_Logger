class AddClientToTimeCard < ActiveRecord::Migration
  def change
    add_column :time_cards, :client, :string
  end
end
