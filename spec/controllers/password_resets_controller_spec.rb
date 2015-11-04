require 'spec_helper'

describe PasswordResetsController do 
  describe "GET show" do 
    it 'renders the password reset page if the token is valid' do 
      john = Fabricate(:user)
      john.update_column(:token, '12345')
      get :show, id: '12345'
      expect(response).to render_template :show 
    end
    
    it 'sets @token' do 
      john = Fabricate(:user)
      john.update_column(:token, '12345')
      get :show, id: '12345'
      expect(assigns(:token)).to eq('12345')
    end
    
    it 'redirects to the expired token page if the token is invalid' do 
      get :show, id: '12345'
      expect(response).to redirect_to expired_token_path 
    end 
  end
  
  describe 'POST create' do 
    context 'with valid token' do 
      it 'redirects to sign in page' do 
        john = Fabricate(:user, password: 'old_password')
        john.update_column(:token, '12345')
        post :create, token: '12345', password: 'new_password'
        expect(response).to redirect_to signin_path 
      end
      
      it "updates the user's password" do 
        john = Fabricate(:user, password: 'old_password')
        john.update_column(:token, '12345')
        post :create, token: '12345', password: 'new_password'
        expect(john.reload.authenticate('new_password')).to be_truthy
      end
      
      it 'sets flash success message' do 
        john = Fabricate(:user, password: 'old_password')
        john.update_column(:token, '12345')
        post :create, token: '12345', password: 'new_password'
        expect(flash[:success]).to be_present 
      end
      
      it 'regenerates the user token' do 
        john = Fabricate(:user, password: 'old_password')
        john.update_column(:token, '12345')
        post :create, token: '12345', password: 'new_password'
        expect(john.reload.token).not_to eq('12345') 
      end
    end 
    
    context 'with invalid token' do 
      it 'redirects to the expired token page' do 
        post :create, token: '12345', password: 'some_password'
        expect(response).to redirect_to expired_token_path
      end
    end
  end
end
