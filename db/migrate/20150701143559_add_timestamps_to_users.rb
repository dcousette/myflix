class AddTimestampsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :created_at, :string
    add_column :users, :updated_at, :string 
  end
end
