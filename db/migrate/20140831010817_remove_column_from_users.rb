class RemoveColumnFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :hashed_password, :string
    remove_column :users, :salt, :string
    remove_column :users, :user_id, :string
  end
end
