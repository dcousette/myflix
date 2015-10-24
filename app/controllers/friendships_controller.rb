class FriendshipsController < ApplicationController
  before_action :require_login
  
  def index 
    @friendships = current_user.following_friendships 
  end
  
  def destroy
    friendship = Friendship.find(params[:id])
    friendship.destroy if current_user == friendship.follower
    redirect_to people_path
  end
end

