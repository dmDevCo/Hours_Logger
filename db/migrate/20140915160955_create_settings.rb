class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.integer :hours_before_email
      t.boolean :hours_alert
      t.integer :days_before_reports
      t.boolean :generate_reports
      t.string :time_zone

      t.timestamps
    end
  end
end
