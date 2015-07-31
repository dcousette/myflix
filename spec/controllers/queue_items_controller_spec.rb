require 'spec_helper'

describe QueueItemsController do 
  describe 'GET index' do 
    it 'sets @queue_items to the queue_items of the logged in user' do 
      alice = Fabricate(:user)
      session[:user_id] = alice.id
      video1 = Fabricate(:video)
      video2 = Fabricate(:video)
      queue_item1 = Fabricate(:queue_item, user: alice, video: video1)
      queue_item2 = Fabricate(:queue_item, user: alice, video: video2)
      get :index
      expect(assigns(:queue_items)).to match_array([queue_item1, queue_item2])
    end
    
    it 'redirects to the sign in page for unauthenticated users' do
      get :index
      expect(response).to redirect_to signin_path
    end
  end
  
  describe 'POST create' do 
    let(:user1){ Fabricate(:user) }
    let(:video){ Fabricate(:video) }
    
    it 'redirects to the my queue page' do
      session[:user_id] = user1.id
      post :create, video_id: Fabricate(:video).id
      expect(response).to redirect_to my_queue_path   
    end
    
    it 'creates a queue item' do
      session[:user_id] = user1.id 
      post :create, video_id: Fabricate(:video).id
      expect(QueueItem.count).to eq(1)
    end
    
    it 'creates the queue item that is associated with the video' do 
      session[:user_id] = user1.id 
      post :create, video_id: video.id
      expect(QueueItem.first.video).to eq(video)
    end
    
    it 'creates the queue item that is associated with the signed in user' do 
      session[:user_id] = user1.id
      post :create, video_id: video.id
      expect(QueueItem.first.user).to eq(user1)
    end 
    
    it 'adds the queue item as last in the order' do 
      session[:user_id] = user1.id
      Fabricate(:queue_item, video_id: video.id, user_id: user1.id)
      simpsons = Fabricate(:video)
      post :create, video_id: simpsons.id
      simpsons_queue_item = QueueItem.find_by(video_id: simpsons.id, user_id: user1.id)
      expect(simpsons_queue_item.position).to eq(2)
    end
    
    it 'does not add the video if the video is already in the queue' do 
      my_item = Fabricate(:queue_item, video_id: video.id, user_id: user1.id)
      session[:user_id] = user1.id
      post :create, video_id: video.id
      expect(user1.queue_items.count).to eq(1)
    end
    
    it 'redirects to the signin page for unauthenticated users' do 
      post :create
      expect(response).to redirect_to signin_path
    end
  end
  
  describe 'DELETE destroy' do
    let(:user1){ Fabricate(:user) }
    let(:video){ Fabricate(:video) }
    let(:my_item){ Fabricate(:queue_item, video: video, user: user1) }

    it 'removes the queue item from the database' do 
      session[:user_id] = user1.id
      delete :destroy, id: my_item.id 
      expect(QueueItem.count).to eq(0) 
    end 
    
    it 'redirects back to the myqueue page' do 
      session[:user_id] = user1.id
      delete :destroy, id: my_item.id 
      expect(response).to redirect_to my_queue_path
    end
    
    it 'does not let a user delete queue_items that are not in their queue' do 
      user2 = Fabricate(:user)
      user_1_item = Fabricate(:queue_item, video: video, user: user1)
      user_2_item = Fabricate(:queue_item, video: video, user: user2)
      session[:user_id] = user1.id
      delete :destroy, id: user_2_item.id
      expect(QueueItem.count).to eq(2)
    end 
    
    it 'redirects to signin page for unauthenticated users' do
      delete :destroy, id: my_item.id 
      expect(response).to redirect_to signin_path
    end
  end
end 



