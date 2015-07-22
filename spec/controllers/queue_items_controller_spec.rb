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
    it 'redirects to the queue items page' do 
      user1 = Fabricate(:user)
      session[:user_id] = user1.id 
      post :create, video_id: Fabricate(:video).id, user_id: user1.id
      expect(response).to redirect_to my_queue_path   
    end
    
    it 'creates a queue item' do
      user1 = Fabricate(:user)
      session[:user_id] = user1.id 
      post :create, video_id: Fabricate(:video).id, user_id: user1.id
      expect(QueueItem.count).to eq(1)
    end
    
    it 'creates the queue item that is associated with the video' do 
      user1 = Fabricate(:user)
      video = Fabricate(:video)
      session[:user_id] = user1.id
      post :create, video_id: video.id, user_id: user1.id
      expect(assigns(:queue_item).video).to eq(video)
    end
    
    it 'creates the queue item that is associated with the signed in user' do 
      user1 = Fabricate(:user)
      video = Fabricate(:video)
      session[:user_id] = user1.id
      post :create, video_id: video.id, user_id: user1.id
      expect(assigns(:queue_item).user).to eq(user1)
    end 
    
    it 'adds the queue item as last in the order' do 
      user1 = Fabricate(:user)
      video = Fabricate(:video)
      session[:user_id] = user1.id
      post :create, video_id: video.id, user_id: user1.id
      expect(assigns(:queue_item)).to eq(user1.queue_items.last)
    end
    
    it 'does not add the video if the video is already in the queue' do 
      user1 = Fabricate(:user)
      video = Fabricate(:video)
      my_item = Fabricate(:queue_item, video_id: video.id, user_id: user1.id)
      session[:user_id] = user1.id
      post :create, video_id: video.id, user_id: user1.id
      expect(user1.queue_items.count).to eq(1)
    end
    
    it 'redirects to the signin page for unauthenticated users' do 
      post :create
      expect(response).to redirect_to signin_path
    end
  end
end 



