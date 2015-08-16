require 'spec_helper'

describe VideosController do
  before { setup_current_user }
  let(:video) { Fabricate(:video) }
  
  describe 'GET show' do
    it 'sets @video for authenticated users' do
      get :show, id: video.id
      expect(assigns(:video)).to eq(video)
    end
    
    it 'sets @reviews for authenticated users' do 
      review1 = Fabricate(:review, video: video)
      review2 = Fabricate(:review, video: video)
      get :show, id: video.id
      expect(assigns(:reviews)).to match_array([review2, review1])
    end
    
    it 'sets up the @review variable for authenticated users' do 
      get :show, id: video.id 
      expect(assigns(:review)).to be_instance_of(Review)
    end
    
    it_behaves_like "require_sign_in" do 
      let(:action) { get :show, id: video.id }
    end
  end
   
  describe 'POST search' do 
    it 'sets @results for authenticated users' do 
      futurama = Fabricate(:video, title:'Futurama')
      post :search, search_term: 'rama'
      expect(assigns(:results)).to eq([futurama])
    end
    
    it_behaves_like "require_sign_in" do 
      let(:action) { post :search, search_term: 'rama' }
    end
  end
end