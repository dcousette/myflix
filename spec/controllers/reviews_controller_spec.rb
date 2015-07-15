require 'spec_helper'

describe ReviewsController do
  describe 'POST create' do 
    context 'with a valid form submission' do 
      before do 
        session[:user_id] = Fabricate(:user).id
        post :create, review: Fabricate.attributes_for(:review)  
      end
      
      it 'creates a review object in the database' do 
        expect(Review.count).to eq(1)
      end
      
      it 'redirects user to the video show page' do 
        expect(response).to redirect_to videos_path
      end
      
      it 'sets the notice' do 
        expect(flash[:notice]).not_to be_nil 
      end
    end
    
    context 'with an invalid form submission' do
      before do 
        session[:user_id] = Fabricate(:user).id
        post :create, review: {rating: 1}
      end 
      
      it 'it does not create a review in the db' do 
        expect(Review.count).to eq(0)
      end
      
      it 'renders the home page' do 
        expect(response).to redirect_to home_path
      end
    end
    
    context 'with unauthenticated user' do 
      before do 
        session[:user_id] = nil
        post :create, review: Fabricate.attributes_for(:review)
      end
      
      it 'redirects the user to sign in page' do 
        expect(response).to redirect_to signin_path
      end
      
      it 'does not create a user in the db' do 
        expect(Review.count).to eq(0)
      end
    end
  end
end