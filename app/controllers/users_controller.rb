class UsersController < ApplicationController
  before_action :require_login, only: [:show]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      handle_invitation
      AppMailer.send_welcome_email(@user).deliver 
      redirect_to signin_path
    else
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

  def handle_invitation
    if params[:invitation_token].present?
      invitation = Invitation.find_by(token: params[:invitation_token])
      @user.follow_each_other(invitation.inviter)
      invitation.update_columns(token: nil)
    end
  end

  def user_params
    params.require(:user).permit(:email_address, :password, :full_name)
  end
end
