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
end