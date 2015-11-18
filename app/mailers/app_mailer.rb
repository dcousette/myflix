class AppMailer < ActionMailer::Base
  default from: 'info@myflix.com'

  def send_welcome_email(user)
    @user = user
    mail to: user.email_address, subject: 'Welcome to Myflix!'
  end

  def send_password_reset(user)
    @user = user
    mail to: user.email_address, subject: 'Password Reset'
  end

  def send_invitation_email(invitation)
    @invitation = invitation
    mail to: invitation.recipient_email, subject: 'Join Myflix Today!'
  end
end
