require 'spec_helper'

describe FriendshipsController do 
  describe 'GET index' do 
    it 'sets @friendships to the current users following friendships' do 
      joe = Fabricate(:user)
      jane = Fabricate(:user)
      setup_current_user(joe)
      friends = Fabricate(:friendship, leader: jane, follower: joe)
      get :index
      expect(assigns(:friendships)).to eq([friends])
    end 
    
    it_behaves_like 'require_sign_in' do 
      let(:action) { get :index }
    end
  end
  
  describe 'DELETE destroy' do 
    it_behaves_like 'require_sign_in' do 
      let(:action) { delete :destroy, id: 4 } 
    end
    
    it 'deletes the friendship if the current user is the follower' do 
      john = Fabricate(:user)
      jane = Fabricate(:user)
      setup_current_user(john)
      friends = Fabricate(:friendship, leader: jane, follower: john)
      delete :destroy, id: friends.id 
      expect(Friendship.count).to eq(0)
    end 
    
    it 'redirects back to the people page' do
      john = Fabricate(:user)
      jane = Fabricate(:user)
      setup_current_user(john)
      friends = Fabricate(:friendship, leader: jane, follower: john)
      delete :destroy, id: friends.id 
      expect(response).to redirect_to people_path
    end
    
    it 'does not delete the friendship if the current user is not the follower' do 
      john = Fabricate(:user)
      jane = Fabricate(:user)
      deshawn = Fabricate(:user)
      setup_current_user(john)
      friends = Fabricate(:friendship, leader: deshawn, follower: jane)
      delete :destroy, id: friends.id 
      expect(Friendship.count).to eq(1)
    end
  end
end