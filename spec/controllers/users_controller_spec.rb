require 'spec_helper'

describe UsersController do
  describe 'GET new' do
    it 'sets @user' do
      get :new
      expect(assigns(:user)).to be_instance_of(User)
    end
  end

  describe 'POST create' do
    context 'with valid input' do
      let(:charge) { double(:charge, successful?: true) }
      let(:alice) { Fabricate(:user) }
      let(:invitation) { Fabricate(:invitation, inviter: alice,
                              recipient_email: 'joe@example.com') }

      before { StripeWrapper::Charge.should_receive(:create).and_return(charge) }

      it 'creates the user' do
        post :create, user: Fabricate.attributes_for(:user)
        expect(User.count).to eq(1)
      end

      it 'redirects to the sign in page' do
        post :create, user: Fabricate.attributes_for(:user)
        expect(response).to redirect_to signin_path
      end

      it 'makes the user follow the inviter' do
        post :create, user: { email_address: 'joe@example.com', password: 'mypassword',
                              full_name: 'Joe Blow' }, invitation_token: invitation.token
        joe = User.find_by(email_address: 'joe@example.com')
        expect(joe.follows?(alice)).to be_truthy
      end

      it 'makes the inviter follow the user' do
        post :create, user: { email_address: 'joe@example.com', password: 'mypassword',
                              full_name: 'Joe Blow' }, invitation_token: invitation.token
        joe = User.find_by(email_address: 'joe@example.com')
        expect(alice.follows?(joe)).to be_truthy
      end

      it 'expires the invitation after acceptance' do
        post :create, user: { email_address: 'joe@example.com', password: 'mypassword',
                              full_name: 'Joe Blow' }, invitation_token: invitation.token
        expect(invitation.reload.token).to be_nil
      end
    end

    context 'with valid personal information and a declined credit card' do
      let(:charge) { double(:charge, successful?: false, error_message: 'Your card was declined') }
      before { StripeWrapper::Charge.should_receive(:create).and_return(charge) }

      it 'does not create a new user' do
        post :create, user: Fabricate.attributes_for(:user), stripeToken: '123321'
        expect(User.count).to eq(0)
      end

      it 'sets the flash error message' do
        post :create, user: Fabricate.attributes_for(:user), stripeToken: '123321'
        expect(flash[:danger]).to be_present
      end

      it 'renders the new template' do
        post :create, user: Fabricate.attributes_for(:user), stripeToken: '123321'
        expect(response).to render_template :new
      end
    end

    context 'with invalid input' do
      it 'does not create the user' do
        post :create, user: {password:'dcousette', full_name:'DeShawn Cousette'}
        expect(User.count).to eq(0)
      end

      it 'renders the :new template' do
        post :create, user: {password:'dcousette', full_name:'DeShawn Cousette'}
        expect(response).to render_template :new
      end

      it 'does not charge the card' do
        post :create, user: {password:'dcousette', full_name:'DeShawn Cousette'}
      end

      it 'does not send an email with invalid input' do
        post :create, user: { full_name: "Johnny Football", email_address: ""}
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end

    context 'sending emails' do
      before { StripeWrapper::Charge.should_receive(:create).and_return(charge) }
      let(:charge) { double(:charge, successful?: true) }
      after { ActionMailer::Base.deliveries.clear }

      it 'sends an email to the newly created user with valid input' do
        post :create, user: Fabricate.attributes_for(:user, email_address: "john@example.com")
        expect(ActionMailer::Base.deliveries.last.to).to eq(["john@example.com"])
      end

      it 'sends an email containing the users name with valid input' do
        post :create, user: Fabricate.attributes_for(:user, full_name: "Johnny Football")
        expect(ActionMailer::Base.deliveries.last.body).to include("Johnny Football")
      end
    end
  end

  describe 'GET show' do
    it_behaves_like "require_sign_in" do
      let(:action) { get :show, id: 4 }
    end

    it 'sets a user from the database in @user' do
      set_current_user
      user = Fabricate(:user)
      get :show, id: user.id
      expect(assigns(:user)).to eq(user)
    end
  end

  describe "GET new_with_invitation_token" do
    it 'renders the new template' do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(response).to render_template :new
    end

    it "sets @user with the recipient's email" do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(assigns(:user).email_address).to eq(invitation.recipient_email)
    end

    it 'sets @invitation_token' do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(assigns(:invitation_token)).to eq(invitation.token)
    end

    it 'redirects to the expired token page for invalid tokens' do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: 'fugazitokenz!'
      expect(response).to redirect_to expired_token_path
    end
  end
end
