include ApplicationHelper

RSpec::Matchers.define :have_error_message do |msg|
	match do |page|
		page.should have_selector("div.alert.alert-error")
	end
end

def sign_in(user)
	visit signin_path
	fill_in "Email",		with: user.email
  fill_in "Password",	with: user.password
  click_button "Sign In"
  #sign in when not using capybara
  cookies[:remember_token]=user.remember_token
end