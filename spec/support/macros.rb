def setup_current_user(user=nil)
  session[:user_id] = (user || Fabricate(:user)).id 
end