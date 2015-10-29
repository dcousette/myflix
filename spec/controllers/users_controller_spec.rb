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
    
    context 'sending emails' do
      after { ActionMailer::Base.deliveries.clear }
      
      it 'sends an email to the newly created user with valid input' do 
        post :create, user: Fabricate.attributes_for(:user, email_address: "john@example.com")
        expect(ActionMailer::Base.deliveries.last.to).to eq(["john@example.com"])
      end
      
      it 'sends an email containing the users name with valid input' do 
        post :create, user: Fabricate.attributes_for(:user, full_name: "Johnny Football")
        expect(ActionMailer::Base.deliveries.last.body).to include("Johnny Football")
      end
      
      it 'does not send an email with invalid input' do 
        post :create, user: { full_name: "Johnny Football" }
        expect(ActionMailer::Base.deliveries).to be_empty
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
