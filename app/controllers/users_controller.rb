class UsersController < ApplicationController
  before_action :require_login, only: [:show]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    result = UserSignUp.new(@user).sign_up(params[:stripeToken], params[:invitation_token])

    if result.successful?
      flash[:success] = "Thank you for registering with Myflix. Please sign in now."
      redirect_to signin_path
    else
      flash.now[:danger] = result.error_message
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def new_with_invitation_token
    invitation = Invitation.find_by(token: params[:token])

    if invitation
      @invitation_token = invitation.token
      @user = User.new(email_address: invitation.recipient_email)
      render :new
    else
      redirect_to expired_token_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:email_address, :password, :full_name)
  end
end
