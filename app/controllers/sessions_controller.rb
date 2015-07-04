class SessionsController < ApplicationController
  def create
    user = User.find_by(email_address: params[:email_address])
    
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = "You are logged in"
      redirect_to videos_path
    else
      flash[:danger] = 'Please enter the correct username and password'
      render :new
    end
  end
  
  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end
end