require 'spec_helper'

describe InvitationsController do
  describe "GET new" do
    it_behaves_like "require_sign_in" do
      let(:action) { get :new }
    end

    it 'sets @invitation to a new invitation' do
      set_current_user
      get :new
      expect(assigns(:invitation)).to be_new_record
      expect(assigns(:invitation)).to be_instance_of(Invitation)
    end
  end

  describe "POST create" do
    it_behaves_like "require_sign_in" do
      let(:action) { post :create }
    end

    context 'with valid input' do
      it 'creates an invitation' do
        set_current_user
        post :create, invitation: { recipient_name: "John Smith", recipient_email: "jsmith@gmail.com",
                        message: "This is cool!"}
        expect(Invitation.count).to eq(1)
      end

      it 'redirects to the invitation new page' do
        set_current_user
        post :create, invitation: { recipient_name: "John Smith", recipient_email: "jsmith@gmail.com",
                        message: "This is cool!"}
        expect(response).to redirect_to invite_path
      end

      it 'sends an invite email to the recipient'

      it 'sets the flash message'
    end
    context 'with invalid input'

    it 'sends an invite email to the friends email address'
    it 'redirects to invite sent confirmation page'
    it 'it does not send an email if the email address is blank'
    it ''
  end
end
