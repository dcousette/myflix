require 'spec_helper'

describe Admin::VideosController do
  describe "GET new" do
    it_behaves_like "require_sign_in" do
      let(:action) { get :new }
    end

    it_behaves_like "require_admin" do
      let(:action) { get :new }
    end

    it 'sets @video to a new video' do
      set_current_admin
      get :new
      expect(assigns(:video)).to be_an_instance_of(Video)
    end
  end

  describe "POST create" do
    it_behaves_like "require_sign_in" do
      let(:action) { post :create }
    end

    it_behaves_like "require_admin" do
      let(:action) { post :create }
    end

    context 'with valid input' do
      before { set_current_admin }

      it 'adds a video to the database' do
        category = Fabricate(:category)
        post :create, video: Fabricate.attributes_for(:video, category: category)
        expect(category.videos.count).to eq(1)
      end

      it 'uploads a video file'

      it 'it redirects to the add new videos path' do
        post :create, video: Fabricate.attributes_for(:video)
        expect(response).to redirect_to new_admin_video_path
      end

      it 'sets the flash success message' do
        post :create, video: Fabricate.attributes_for(:video)
        expect(flash[:success]).to be_present
      end
    end

    context 'with invalid input' do
      before { set_current_admin }

      it 'does not create a video' do
        post :create, video: { description: 'A new movie' }
        expect(Video.first).to eq(nil)
      end

      it 'sets the flash error message' do
        post :create, video: { description: 'A new movie' }
        expect(flash[:danger]).to be_present
      end

      it 'renders the add new video page' do
        post :create, video: { description: 'A new movie' }
        expect(response).to render_template :new
      end

      it 'sets the @video variable' do
        post :create, video: { description: 'A new movie' }
        expect(assigns(:video)).to be_an_instance_of(Video)
      end
    end
  end
end
