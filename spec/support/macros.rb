def set_current_user(user=nil)
  session[:user_id] = (user || Fabricate(:user)).id
end

def set_current_admin(admin=nil)
  session[:user_id] = (admin || Fabricate(:admin)).id
end

def sign_in(user=nil)
  user ||= Fabricate(:user)
  visit signin_path
  fill_in "Email Address", with: user.email_address
  fill_in "Password", with: user.password
  click_button "Sign in"
end

def sign_out
  click_on 'dlabel'
  click_on 'Sign Out'
end

def submit_credit_card(number)
  fill_in 'Credit Card Number', with: number
  fill_in 'Security Code', with: '123'
  select '1 - January', from: 'date_month'
  select '2017', from: 'date_year'
  click_on 'Sign Up'
end
