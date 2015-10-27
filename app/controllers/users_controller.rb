class UsersController < ApplicationController
  before_action :require_login, only: [:show]
  
  def new 
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    
    if @user.save 
      AppMailer.send_welcome_email(@user).deliver 
      redirect_to signin_path
    else 
      render :new
    end
  end
  
  def show 
    @user = User.find(params[:id])
  end
  
  private 
  
  def user_params
    params.require(:user).permit(:email_address, :password, :full_name)
  end
end 