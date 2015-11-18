require 'spec_helper'

describe InvitationsController do
  describe "GET new" do
    it_behaves_like "require_sign_in" do
      let(:action) { get :new }
    end

    it 'sets @invitation to a new invitation' do
      set_current_user
      get :new
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

      it 'sends an invite email to the recipient' do
        set_current_user
        post :create, invitation: { recipient_name: "John Smith", recipient_email: "jsmith@gmail.com",
                        message: "This is cool!"}
        expect(ActionMailer::Base.deliveries.last.to).to eq(['jsmith@gmail.com'])
      end

      it 'sets the flash message' do
        set_current_user
        post :create, invitation: { recipient_name: "John Smith", recipient_email: "jsmith@gmail.com",
                        message: "This is cool!"}
        expect(flash[:success]).to be_present
      end
    end

    context 'with invalid input' do
      after { ActionMailer::Base.deliveries.clear }

      it 'renders the new template' do
        set_current_user
        post :create, invitation: { recipient_name: '', recipient_email: "jsmith@gmail.com", message: "This is invalid!" }
        expect(response).to render_template :new
      end

      it 'does not create an invitation' do
        set_current_user
        post :create, invitation: { recipient_name: '', recipient_email: "jsmith@gmail.com", message: "This is invalid!" }
        expect(Invitation.count).to eq(0)
      end

      it 'does not send an email' do
        set_current_user
        post :create, invitation: { recipient_name: '', recipient_email: "jsmith@gmail.com", message: "This is invalid!" }
        expect(ActionMailer::Base.deliveries.count).to eq(0)
      end

      it 'sets @invitation' do
        set_current_user
        post :create, invitation: { recipient_name: '', recipient_email: "jsmith@gmail.com", message: "This is invalid!" }
        expect(assigns(:invitation)).to be_present
      end

      it 'sets the flash error message' do
        set_current_user
        post :create, invitation: { recipient_name: '', recipient_email: "jsmith@gmail.com", message: "This is invalid!" }
        expect(flash[:danger]).to be_present
      end
    end
  end
end
