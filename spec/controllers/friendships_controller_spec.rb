require 'spec_helper'

describe FriendshipsController do 
  let(:joe) { Fabricate(:user) }
  let(:jane) { Fabricate(:user) }
  let(:deshawn) { Fabricate(:user) }
  let(:john) { Fabricate(:user) }
  
  describe 'GET index' do 
    it 'sets @friendships to the current users following friendships' do 
      set_current_user(joe)
      friends = Fabricate(:friendship, leader: jane, follower: joe)
      get :index
      expect(assigns(:friendships)).to eq([friends])
    end 
    
    it_behaves_like 'require_sign_in' do 
      let(:action) { get :index }
    end
  end
  
  describe 'DELETE destroy' do 
    before { set_current_user(john) }
    
    it_behaves_like 'require_sign_in' do 
      let(:action) { delete :destroy, id: 4 } 
    end
    
    it 'deletes the friendship if the current user is the follower' do 
      friends = Fabricate(:friendship, leader: jane, follower: john)
      delete :destroy, id: friends.id 
      expect(Friendship.count).to eq(0)
    end 
    
    it 'redirects back to the people page' do
      friends = Fabricate(:friendship, leader: jane, follower: john)
      delete :destroy, id: friends.id 
      expect(response).to redirect_to people_path
    end
    
    it 'does not delete the friendship if the current user is not the follower' do 
      friends = Fabricate(:friendship, leader: deshawn, follower: jane)
      delete :destroy, id: friends.id 
      expect(Friendship.count).to eq(1)
    end
  end
  
  describe 'POST create' do
    before { set_current_user(john) }
    
    it_behaves_like 'require_sign_in' do 
      let(:action) { post :create, leader_id: 2}  
    end 
    
    it 'creates a friendship with the current user as the follower' do 
      post :create, leader_id: jane.id
      expect(Friendship.first.follower).to eq(john)
    end
    
    it 'sets the selected user as the leader in the friendship' do 
      post :create, leader_id: jane.id
      expect(Friendship.first.leader).to eq(jane)
    end
    
    it 'redirects to the people page' do 
      post :create, leader_id: jane.id 
      expect(response).to redirect_to people_path
    end
    
    it 'does not create a friendship if the current user is already following the user' do 
      friends = Fabricate(:friendship, leader: jane, follower: john)
      post :create, leader_id: jane.id 
      expect(Friendship.count).to eq(1)
    end
    
    it 'a user cannot follow themselves' do
      post :create, leader_id: john.id 
      expect(Friendship.count).to eq(0)
    end
  end
end