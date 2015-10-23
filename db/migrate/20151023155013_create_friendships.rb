class CreateFriendships < ActiveRecord::Migration
  def change
    create_table :friendships do |t|
      t.integer :leader_id, :follower_id 
      t.timestamps
    end
  end
end
