shared_examples "require_sign_in" do 
  before { session[:user_id] = nil }
  
  it 'redirects back to the sign in page' do
    action 
    expect(response).to redirect_to signin_path
  end
end

