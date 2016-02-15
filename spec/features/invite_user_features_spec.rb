require 'spec_helper'

feature "Invite a user" do
  scenario "User successfully sends and accepts an invitation", { js: true } do
    VCR.use_cassette('invite_stripe_charge') do
      john = Fabricate(:user)
      sign_in(john)
      send_invitation(john)
      click_on "Welcome, #{john.full_name}"
      click_on "Sign Out"

      open_email('jsmith@gmail.com')
      current_email.click_on "Accept this invitation"
      fill_in "Password", with: 'jsmith'
      fill_in "Full Name", with: 'Joe Smith'

      submit_credit_card('4242424242424242')

      fill_in "Email Address", with: 'jsmith@gmail.com'
      fill_in "Password", with: 'jsmith'
      click_on "Sign in"
      #user is not signing in as expected -- how to fix?
      require 'pry'; binding.pry 

      click_on 'People'
      expect(page).to have_content john.full_name
      click_on "Welcome, Joe Smith"
      click_on "Sign Out"

      sign_in(john)
      click_link "People"
      expect(page).to have_content 'Joe Smith'
      clear_emails
    end
  end

  scenario "User unsuccessfully sends an invitation" do
    john = Fabricate(:user)
    sign_in(john)
    click_on "Welcome, #{john.full_name}"
    click_on "Invite a friend"
    fill_in "Friend's Name", with: 'Joe Smith'
    fill_in "Friend's Email Address", with: ''
    click_on "Send invitation"
    expect(page).to have_content "Please check your input"
  end

  def send_invitation(user)
    click_on "Welcome, #{user.full_name}"
    click_on "Invite a friend"
    fill_in "Friend's Name", with: 'Joe Smith'
    fill_in "Friend's Email Address", with: 'jsmith@gmail.com'
    click_on "Send invitation"
  end
end
