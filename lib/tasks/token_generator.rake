desc 'Generates random tokens for the existing users in a database.'
task add_tokens: [:environment] do 
  User.find_each do |user|
    user.generate_token
    user.save 
  end
  
  def generate_token 
    self.token = SecureRandom.urlsafe_base64
  end
  
  puts "Tokens have been generated for #{User.count} users"
end