class FriendshipsController < ApplicationController
  before_action :require_login
  
  def index 
    @friendships = current_user.following_friendships 
  end
  
  def create
    leader = User.find(params[:leader_id])
    
    if current_user.follows?(leader)
      flash[:danger] = "You already follow #{leader.full_name}!" 
    else 
      Friendship.create(leader: leader, follower: current_user) unless leader == current_user
    end
    
    redirect_to people_path
  end
  
  def destroy
    friendship = Friendship.find(params[:id])
    friendship.destroy if current_user == friendship.follower
    redirect_to people_path
  end
end

