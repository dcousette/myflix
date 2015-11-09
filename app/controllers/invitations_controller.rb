class InvitationsController < ApplicationController
  before_action :require_login, only: [:new, :create]

  def new
    @invitation = Invitation.new
  end

  def create
    Invitation.create(invitation_params)
    redirect_to invite_path
  end

  private

  def invitation_params
    params.require(:invitation).permit(:recipient_name, :recipient_email, :message)
  end
end
