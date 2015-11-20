desc 'Generates random tokens for the existing invitations in a database'
task add_invite_tokens: [:environment] do
  Invitation.find_each do |invite|
    invite.generate_token
    invite.save
  end

  def generate_token
    self.token = SecureRandom.urlsafe_base64
  end

  puts "Tokens have been added for #{Invitation.count} invitations"
end
