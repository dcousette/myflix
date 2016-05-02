require 'spec_helper'

describe UserSignUp do
  describe '#sign_up' do
    context 'valid personal info and valid card' do
      let(:customer) { double(:customer, successful?: true, customer_token: 'abcdefg') }
      let(:alice) { Fabricate(:user) }
      let(:invitation) { Fabricate(:invitation, inviter: alice,
                              recipient_email: 'joe@example.com') }

      before { expect(StripeWrapper::Customer).to receive(:create).and_return(customer) }
      after { ActionMailer::Base.deliveries.clear }

      it 'creates the user' do
        UserSignUp.new(Fabricate.build(:user)).sign_up("stripe token", nil)
        expect(User.count).to eq(1)
      end

      it 'makes the user follow the inviter' do
        UserSignUp.new(Fabricate.build(:user, email_address: 'joe@example.com', password: 'mypassword',
                                       full_name: 'Joe Blow')).sign_up("stripe token", invitation.token)
        joe = User.find_by(email_address: 'joe@example.com')
        expect(joe.follows?(alice)).to be_truthy
      end

      it 'stores the customer token from stripe' do
        UserSignUp.new(Fabricate.build(:user)).sign_up("stripe token", nil)
        expect(User.first.customer_token).to eq('abcdefg')
      end

      it 'makes the inviter follow the user' do
        UserSignUp.new(Fabricate.build(:user, email_address: 'joe@example.com', password: 'mypassword',
                                       full_name: 'Joe Blow')).sign_up("stripe token", invitation.token)
        joe = User.find_by(email_address: 'joe@example.com')
        expect(alice.follows?(joe)).to be_truthy
      end

      it 'expires the invitation after acceptance' do
        UserSignUp.new(Fabricate.build(:user, email_address: 'joe@example.com', password: 'mypassword',
                                       full_name: 'Joe Blow')).sign_up("stripe token", invitation.token)
        expect(invitation.reload.token).to be_nil
      end

      it 'sends an email to the newly created user with valid input' do
        UserSignUp.new(Fabricate.build(:user, email_address: 'joe@example.com')).sign_up("stripe token", nil)
        expect(ActionMailer::Base.deliveries.last.to).to eq(["joe@example.com"])
      end

      it 'sends an email containing the users name with valid input' do
        UserSignUp.new(Fabricate.build(:user, email_address: 'joe@example.com', full_name: 'Joe Blow')).sign_up("stripe token", nil)
        expect(ActionMailer::Base.deliveries.last.body).to include("Joe Blow")
      end
    end

    context 'with valid personal information and declined credit card' do
      let(:customer) { double(:customer, successful?: false, error_message: 'Your card was declined') }
      before { expect(StripeWrapper::Customer).to receive(:create).and_return(customer) }

      it 'does not create a new user' do
        UserSignUp.new(Fabricate.build(:user, email_address: 'joe@example.com', password: 'mypassword',
                                       full_name: 'Joe Blow')).sign_up("stripe token", nil)
        expect(User.count).to eq(0)
      end
    end

    context 'with invalid input' do
      it 'does not create the user' do
        UserSignUp.new(User.new(email_address: 'joe@example.com', password: nil,
                                       full_name: 'Joe Blow')).sign_up("stripe token", nil)
        expect(User.count).to eq(0)
      end

      it 'does not charge the card' do
        UserSignUp.new(User.new(email_address: 'joe@example.com', password: nil,
                                       full_name: 'Joe Blow')).sign_up("stripe token", nil)
        expect(StripeWrapper::Customer).not_to receive (:create)
      end

      it 'does not send an email with invalid input' do
        UserSignUp.new(User.new(email_address: 'joe@example.com', password: nil,
                                       full_name: 'Joe Blow')).sign_up("stripe token", nil)
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
  end
end
