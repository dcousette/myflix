require 'spec_helper'

describe UsersController do 
  describe 'GET new' do 
    it 'sets @user' do
      get :new
      expect(assigns(:user)).to be_instance_of(User)
    end
  end
  
  describe 'POST create' do 
    context 'with valid input' do 
      before {post :create, user: Fabricate.attributes_for(:user) }
      
        it 'creates the user' do 
          expect(User.count).to eq(1)                       
        end
        
        it 'redirects to the sign in page' do
          expect(response).to redirect_to signin_path
        end
    end
    
    context 'with invalid input' do 
      before{ post :create, user: {password:'dcousette', full_name:'DeShawn Cousette'}}
      
        it 'does not create the user' do 
          expect(User.count).to eq(0)    
        end
        
        it 'renders the :new template' do 
          expect(response).to render_template :new     
        end 
        
        it 'sets @user' do 
          expect(assigns(:user)).to be_instance_of(User)
        end
    end
  end
  
  describe 'GET show' do 
    it_behaves_like "require_sign_in" do 
      let(:action) { get :show, id: 4 }
    end
    
    it 'sets a user from the database in @user' do 
      set_current_user
      user = Fabricate(:user) 
      get :show, id: user.id
      expect(assigns(:user)).to eq(user)
    end
  end
end
