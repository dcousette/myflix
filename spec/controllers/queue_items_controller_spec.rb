require 'spec_helper'

describe QueueItemsController do 
  describe 'GET index' do 
    it 'sets @queue_items to the queue_items of the logged in user' do 
      alice = Fabricate(:user)
      set_current_user(alice)
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
    
    before { set_current_user(user1) }
    
    it 'redirects to the my queue page' do
      post :create, video_id: Fabricate(:video).id
      expect(response).to redirect_to my_queue_path   
    end
    
    it 'creates a queue item' do
      post :create, video_id: Fabricate(:video).id
      expect(QueueItem.count).to eq(1)
    end
    
    it 'creates the queue item that is associated with the video' do 
      post :create, video_id: video.id
      expect(QueueItem.first.video).to eq(video)
    end
    
    it 'creates the queue item that is associated with the signed in user' do 
      post :create, video_id: video.id
      expect(QueueItem.first.user).to eq(user1)
    end 
    
    it 'adds the queue item as last in the order' do 
      Fabricate(:queue_item, video_id: video.id, user_id: user1.id)
      simpsons = Fabricate(:video)
      post :create, video_id: simpsons.id
      simpsons_queue_item = QueueItem.find_by(video_id: simpsons.id, user_id: user1.id)
      expect(simpsons_queue_item.position).to eq(2)
    end
    
    it 'does not add the video if the video is already in the queue' do 
      my_item = Fabricate(:queue_item, video_id: video.id, user_id: user1.id)
      post :create, video_id: video.id
      expect(user1.queue_items.count).to eq(1)
    end
    
    it_behaves_like "require_sign_in" do 
      let(:action) { post :create }
    end
  end
  
  describe 'DELETE destroy' do
    let(:user1){ Fabricate(:user) }
    let(:video){ Fabricate(:video) }
    let(:my_item){ Fabricate(:queue_item, video: video, user: user1) }
    
    before { set_current_user(user1) }
    
    it 'removes the queue item from the database' do 
      delete :destroy, id: my_item.id 
      expect(QueueItem.count).to eq(0) 
    end 
    
    it 'redirects back to the myqueue page' do 
      delete :destroy, id: my_item.id 
      expect(response).to redirect_to my_queue_path
    end
    
    it 'does not let a user delete queue_items that are not in their queue' do 
      user2 = Fabricate(:user)
      user_1_item = Fabricate(:queue_item, video: video, user: user1)
      user_2_item = Fabricate(:queue_item, video: video, user: user2)
      delete :destroy, id: user_2_item.id
      expect(QueueItem.count).to eq(2)
    end 
    
    it_behaves_like "require_sign_in" do 
      let(:action) { delete :destroy, id: my_item.id }
    end
    
    it 'normalizes the remaining queue items' do 
      item1 = Fabricate(:queue_item, user: user1, position: 1 )
      item2 = Fabricate(:queue_item, user: user1, position: 2 )
      item3 = Fabricate(:queue_item, user: user1, position: 3 )
      delete :destroy, id: item2.id 
      expect(item3.reload.position).to eq(2) 
    end 
  end
  
  describe 'POST update_queue' do
    context 'with valid information' do 
      let(:alice) { Fabricate(:user) }
      let(:video) { Fabricate(:video) }
      let(:queue_item1) { Fabricate(:queue_item, user: alice, position: 1, video: video ) } 
      let(:queue_item2) { Fabricate(:queue_item, user: alice, position: 2, video: video ) }
      
      before do 
        set_current_user(alice)
      end
      
      it 'redirects to the myqueue page' do 
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2 }, {id: queue_item2.id, position: 1 }]
        expect(response).to redirect_to my_queue_path 
      end
      
      it 'reorders the queue items' do 
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2 }, {id: queue_item2.id, position: 1 }]
        expect(alice.queue_items).to eq([queue_item2, queue_item1])
      end
      
      it 'normalizes the position numbers' do 
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3 }, {id: queue_item2.id, position: 1 }]
        expect(alice.queue_items.map(&:position)).to eq([1, 2])  
      end 
    end
    
    context 'with invalid information' do
      let(:alice) { Fabricate(:user) }
      let(:video) { Fabricate(:video) }
      let(:queue_item1) { Fabricate(:queue_item, user: alice, position: 1, video: video ) } 
      let(:queue_item2) { Fabricate(:queue_item, user: alice, position: 2, video: video ) }
      
      before do 
        set_current_user(alice) 
      end
      
      it 'redirects to the myqueue page' do 
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2.2 }, {id: queue_item2.id, position: 1 }]
        expect(response).to redirect_to my_queue_path
      end
      
      it 'sets the flash error message' do 
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2.2 }, {id: queue_item2.id, position: 1 }]
        expect(flash[:error]).to be_present
      end 
      
      it 'does not change the queue items' do 
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3 }, {id: queue_item2.id, position: 1.5 }]
        expect(queue_item1.reload.position).to eq(1)
      end
    end
    
    context 'with que item that does not belong to current user' do 
      it 'does not change the queue items' do
        alice = Fabricate(:user)
        john = Fabricate(:user)
        video = Fabricate(:video)
        set_current_user(alice)
        queue_item1 = Fabricate(:queue_item, user: john, position: 1, video: video)
        queue_item2 = Fabricate(:queue_item, user: alice, position: 2, video: video)
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2 }, {id: queue_item2.id, position: 1 }]
        expect(queue_item1.reload.position).to eq(1)
      end 
    end
    
    it_behaves_like "require_sign_in" do 
      let(:action) do 
        post :update_queue, queue_items: [{id: 1, position: 2 }, {id: 2, position: 1 }]
      end
    end
  end
end 