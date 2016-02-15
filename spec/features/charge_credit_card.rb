require 'spec_helper'

feature 'Charging a credit card', { js: true } do
  background { visit register_path }

  scenario 'signup with valid user info and valid credit card' do
    VCR.use_cassette('create_stripe_charge') do
      complete_registration
      submit_credit_card('4242424242424242')
      expect(page).to have_content 'Thank you for registering with Myflix'
    end
  end

  scenario 'signup with valid user info and invalid credit card' do
    VCR.use_cassette('create_stripe_charge') do
      complete_registration
      submit_credit_card('4000000000678266')
      expect(page).to have_content 'Your card number is incorrect.'
    end
  end

  scenario 'signup with valid user info and declined credit card' do
    VCR.use_cassette('declined_stripe_charge') do
      complete_registration
      submit_credit_card('4242424242424242')
      expect(page).to have_content 'Your card was declined.'
    end
  end

  scenario 'signup with invalid user info and valid credit card' do
    VCR.use_cassette('create_stripe_charge') do
      incomplete_registration
      submit_credit_card('4242424242424242')
      expect(page).to have_content "can't be blank"
    end
  end

  scenario 'signup with invalid user info and invalid credit card' do
    VCR.use_cassette('create_stripe_charge') do
      incomplete_registration
      submit_credit_card('4000000000678266')
      expect(page).to have_content 'Your card number is incorrect.'
    end
  end

  scenario 'signup with invalid user info and declined credit card' do
    VCR.use_cassette('declined_stripe_charge') do
      incomplete_registration
      submit_credit_card('4000000000000002')
      expect(page).to have_content "can't be blank"
    end
  end

  def complete_registration
    fill_in 'Email Address', with: 'joesmith@gmail.com'
    fill_in 'Password', with: 'joesmith'
    fill_in 'Full Name', with: 'Joe Smith'
  end

  def incomplete_registration
    fill_in 'Email Address', with: 'joesmith@gmail.com'
    fill_in 'Full Name', with: 'Joe Smith'
  end
end
