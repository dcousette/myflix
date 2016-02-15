require 'spec_helper'

feature "Invite a user" do
  scenario "User successfully sends and accepts an invitation", { js: true } do
    VCR.use_cassette('accept_invite_and_charge_card') do
      john = Fabricate(:user)
      sign_in(john)

      send_invitation(john)
      friend_accepts_invitation
      friend_signs_in

      friend_should_follow(john)
      inviter_should_follow_friend(john)

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
    click_on "Welcome, #{user.full_name}"
    click_on "Sign Out"
  end

  def friend_accepts_invitation
    open_email('jsmith@gmail.com')
    current_email.click_on "Accept this invitation"
    fill_in "Password", with: 'jsmith'
    fill_in "Full Name", with: 'Joe Smith'
    submit_credit_card('4242424242424242')
    sleep 1
  end

  def friend_signs_in
    fill_in "Email Address", with: 'jsmith@gmail.com'
    fill_in "Password", with: 'jsmith'
    click_on "Sign in"
  end

  def friend_should_follow(user)
    click_on 'People'
    expect(page).to have_content user.full_name
    click_on "Welcome, Joe Smith"
    click_on "Sign Out"
  end

  def inviter_should_follow_friend(inviter)
    sign_in(inviter)
    click_link "People"
    expect(page).to have_content 'Joe Smith'
    click_on "Welcome, #{inviter.full_name}"
    click_on "Sign Out"
  end
end
