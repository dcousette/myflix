class InvitationsController < ApplicationController
  before_action :require_login, only: [:new, :create]

  def new
    @invitation = Invitation.new
  end

  def create
    @invitation = Invitation.create(invitation_params)

    if @invitation.save
      AppMailer.send_invitation_email(@invitation).deliver
      flash[:success] = 'Your invitation has been sent.'
      redirect_to invite_path
    else
      flash[:danger] = "Please check your input."
      render :new
    end
  end

  private

  def invitation_params
    params.require(:invitation).permit(:recipient_name, :recipient_email, :message).merge!(inviter_id: current_user.id)
  end
end
