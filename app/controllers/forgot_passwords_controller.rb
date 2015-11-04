class ForgotPasswordsController < ApplicationController
  def create
    user = User.find_by(email_address: params[:email_address])
    
    if user
      AppMailer.send_password_reset(user).deliver
      redirect_to forgot_password_confirmation_path
    else
      flash[:danger] = params[:email_address].blank? ? "The email address cannot be blank" : "This user does not exist"
      redirect_to forgot_password_path
    end
  end
end