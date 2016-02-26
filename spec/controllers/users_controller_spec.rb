require 'spec_helper'

describe UsersController do
  describe 'GET new' do
    it 'sets @user' do
      get :new
      expect(assigns(:user)).to be_instance_of(User)
    end
  end

  describe 'POST create' do
    context 'successful user sign up' do
      it 'redirects to the sign in page' do
        result = double(:sign_up_result, successful?: true)
        UserSignUp.any_instance.should_receive(:sign_up).and_return(result)
        post :create, user: Fabricate.attributes_for(:user)
        expect(response).to redirect_to signin_path
      end
    end

    context 'failed user sign up' do
      it 'sets the flash error message' do
        result = double(:sign_up_result, successful?: false, error_message: "This is an error message.")
        UserSignUp.any_instance.should_receive(:sign_up).and_return(result)
        post :create, user: Fabricate.attributes_for(:user), stripeToken: '123321'
        expect(flash[:danger]).to be_present
      end

      it 'renders the new template' do
        result = double(:sign_up_result, successful?: false, error_message: "This is an error message.")
        UserSignUp.any_instance.should_receive(:sign_up).and_return(result)
        post :create, user: Fabricate.attributes_for(:user), stripeToken: '123321'
        expect(response).to render_template :new
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
