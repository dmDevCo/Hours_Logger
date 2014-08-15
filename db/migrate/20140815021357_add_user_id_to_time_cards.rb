class AddUserIdToTimeCards < ActiveRecord::Migration
  def change
    add_column :time_cards, :user_id, :integer
  end
end
