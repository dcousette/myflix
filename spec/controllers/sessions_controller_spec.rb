require 'spec_helper'

describe SessionsController do 
  
  describe 'GET new' do 
    it 'renders the new template for unauthenticated users' do 
      get :new 
      expect(response).to render_template :new 
    end
    
    it 'redirects to the home page for authenticated users' do 
      set_current_user
      get :new 
      expect(response).to redirect_to home_path
    end
  end
  
  describe 'POST create' do 
    context 'with valid credentials' do
      before do 
        post :create, email_address: alice.email_address, password: alice.password
      end
      
      let(:alice) { Fabricate(:user) }
      
      it 'puts the signed in user in the session' do 
        expect(session[:user_id]).to eq(alice.id)
      end 
      
      it 'redirects to the home path' do 
        expect(response).to redirect_to home_path
      end 
      
      it 'sets the notice' do 
        expect(flash[:success]).not_to be_blank
      end
    end
    
    context 'with invalid credentials' do
      before do 
        alice = Fabricate(:user)
        post :create, email_address: alice.email_address, password: alice.password + 'hkjhjghjg'
      end
      
      it 'does not put a user in the session' do
        expect(session[:user_id]).to be_nil 
      end
      
      it 'renders the new template' do 
        expect(response).to render_template :new 
      end 
      
      it 'sets the notice' do 
        expect(flash[:danger]).to be_present 
      end 
    end
  end
  
  describe 'DELETE destroy' do 
    before do 
      set_current_user
      delete :destroy
    end
    
    it 'removes the user from the session' do 
      expect(session[:user_id]).to be_nil 
    end
    
    it 'redirects to the root path' do 
      expect(response).to redirect_to root_path 
    end
  end
end