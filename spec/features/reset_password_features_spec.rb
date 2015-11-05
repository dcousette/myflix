require 'spec_helper'

feature 'Reset password' do
  scenario 'user sends forgot password email' do
    joe = Fabricate(:user, password: 'old password')
    visit signin_path
    click_on "Forgot Password?"
    fill_in "Email Address", with: joe.email_address 
    click_on "Send Email"
    
    open_email(joe.email_address)
    current_email.click_link "Reset My Password"
    fill_in "New Password", with: "new password"
    click_on 'Reset Password'
    expect(page).to have_content("Your password has been changed. Please sign in.")
    
    fill_in "Email Address", with: joe.email_address
    fill_in "Password", with: 'new password'
    click_on "Sign in"
    expect(page).to have_content("You are logged in")
  end 
end