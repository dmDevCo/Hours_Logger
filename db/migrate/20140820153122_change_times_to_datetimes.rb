class ChangeTimesToDatetimes < ActiveRecord::Migration
  def change
	change_column :time_cards, :time_started, :datetime
	change_column :time_cards, :time_stopped, :datetime
  end
end
