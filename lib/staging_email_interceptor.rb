class StagingEmailInterceptor
  def self.delivering_email(message)
    message.to = ['dcousette@gmail.com']
  end
end 
