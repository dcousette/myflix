shared_examples "require_sign_in" do
  before { session[:user_id] = nil }

  it 'redirects back to the sign in page' do
    action
    expect(response).to redirect_to signin_path
  end
end

shared_examples "tokenable" do
  it 'generates a random token for the object when it is created' do
    expect(object.token).to be_present
  end
end

shared_examples "require_admin" do
  before { set_current_user }

  it 'redirects a regular user to the home page' do
    action
    expect(response).to redirect_to home_path
  end

  it 'sets the flash error message for regular user' do
    action
    expect(flash[:danger]).to eq("Access denied!")
  end
end
