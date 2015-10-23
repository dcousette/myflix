class FriendshipsController < ApplicationController
  before_action :require_login, only: [:index]
  
  def index 
    @friendships = current_user.following_friendships 
  end
end

