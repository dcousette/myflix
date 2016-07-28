require 'spec_helper'

feature 'Admin sees payments' do
  background do
    jim = Fabricate(:user, full_name: 'Jim Doe', email_address: 'jimdoe@gmail.com')
    Fabricate(:payment, user: jim, amount: 999)
  end

  scenario 'admin can see payments' do
    sign_in(Fabricate(:admin))
    visit admin_payments_path
    expect(page).to have_content("$9.99")
    expect(page).to have_content('Jim Doe')
    expect(page).to have_content('jimdoe@gmail.com')
  end

  scenario 'user cannot see payments' do
    sign_in(Fabricate(:user))
    visit admin_payments_path
    expect(page).to have_no_content("$9.99")
    expect(page).to have_no_content('Jim Doe')
    expect(page).to have_content("Access denied!")
  end
end
