require 'spec_helper'

describe ForgotPasswordsController do
  describe 'POST create' do

    context 'with blank email' do
      it 'redirects to the forgot password page' do
        post :create, email_address: ''
        expect(response).to redirect_to forgot_password_path
      end

      it 'displays and error message' do
        post :create, email_address: ''
        expect(flash[:danger]).to eq("The email address cannot be blank")
      end
    end

    context 'with existing email' do
      after { ActionMailer::Base.deliveries.clear }

      it 'redirects to the forgot password confirmation page' do 
        Fabricate(:user, email_address: "joe@example.com")
        post :create, email_address: "joe@example.com"
        expect(response).to redirect_to forgot_password_confirmation_path
      end

      it 'sends an email to the email address' do
        Fabricate(:user, email_address: "joe@example.com")
        post :create, email_address: "joe@example.com"
        expect(ActionMailer::Base.deliveries.last.to).to eq(["joe@example.com"])
      end

      it 'generates a token for the user' do
        joe = Fabricate(:user, email_address: "joe@example.com")
        post :create, email_address: "joe@example.com"
        expect(joe.token).to be_present
      end
    end

    context 'with non existing email' do
      before { Fabricate(:user, email_address: "joe@example.com") }

      it 'redirects to the forgot password page' do
        post :create, email_address: "test@test.com"
        expect(response).to redirect_to forgot_password_path
      end

      it 'displays an error message' do
        post :create, email_address: "test@test.com"
        expect(flash[:danger]).to eq("This user does not exist")
      end
    end
  end
end
