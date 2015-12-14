require 'spec_helper'

describe Admin::VideosController do
  describe "GET new" do
    it_behaves_like "require_sign_in" do
      let(:action) { get :new }
    end

    it 'sets @video to a new video' do
      admin_user = Fabricate(:user, admin: true)
      set_current_admin
      get :new
      expect(assigns(:video)).to be_an_instance_of(Video)
    end

    it 'redirects a regular user to the home page' do
      regular_user = Fabricate(:user, admin: false)
      set_current_user(regular_user)
      get :new
      expect(response).to redirect_to home_path
    end

    it 'sets the flash error message for regular user' do
      regular_user = Fabricate(:user, admin: false)
      set_current_user(regular_user)
      get :new
      expect(flash[:danger]).to eq("Access denied!")
    end
  end
end
