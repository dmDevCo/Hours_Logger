class CreateTimeCards < ActiveRecord::Migration
  def change
    create_table :time_cards do |t|
      t.time :time_started
      t.time :time_stopped
      t.date :date
      t.string :message

      t.timestamps
    end
  end
end
