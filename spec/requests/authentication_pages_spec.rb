require 'spec_helper'

describe "Authentication" do
	subject { page }

	describe "sign in page" do
		before { visit signin_path }
		it { should have_selector("h1",		text: "Sign In")}
		it { should have_selector("title",	text: "Sign In")}
	end

	describe "signin" do
		before { visit signin_path }

		describe "with invalid info" do
			before { click_button "Sign In"}
			it { should have_selector("title",	text: "Sign In")}
			it { should have_error_message }
			
			describe "after visiting another page" do
				before { click_link "Home" }
				it { should_not have_error_message }
			end
		end

		describe "with valid info" do
			let(:user) { FactoryGirl.create(:user) }
			before { sign_in user }

			it { should have_selector("title",	text: user.name) }
			it { should have_link("Profile",		href: user_path(user)) }
			it { should have_link("Sign Out",		href: signout_path) }
			it { should have_link("Settings",		href: edit_user_path(user)) }
			it { should have_link("Users",			href: users_path) }
			it { should_not have_link("Sign In",href: signin_path) }

			describe "followed by sign out" do
				before { click_link "Sign Out" }
				it { should have_link("Sign In",	href: signin_path) }
			end
		end
	end

	describe "autorization" do
		describe "for non signed-in users" do
			let(:user) { FactoryGirl.create(:user) }

			describe "when trying to visit a protected page" do
				before do
				  visit edit_user_path(user)
				  fill_in "Email",		with: user.email
				  fill_in "Password",	with: user.password
				  click_button "Sign In"
				end

				describe "after signing in" do
					it "should render the desired page" do
						page.should have_selector("title", text: "Edit user")
					end
					
					describe "after signing in again" do
						before do
						  click_link "Sign Out"
						  sign_in user
						end

						it "should render the default page" do
							page.should have_selector("title", text: user.name)
						end
					end
				end
			end

			describe "in the users controller" do
				describe "visiting the edit page" do
					before { visit edit_user_path(user) }
					it { should have_selector("div.alert.alert-notice") }
				end

				describe "invoking the update action" do
					before { put user_path(user) }
					specify { response.should redirect_to(signin_path) }
				end

				describe "visiting the Users index" do
					before { visit users_path }
					it { should have_selector("title", text: "Sign In") }
				end
			end
		end

		describe "as a different user" do
			let(:user) { FactoryGirl.create(:user) }
			let(:other_user) { FactoryGirl.create(:user, email: "other@user.com") }

			before { sign_in user }
			describe "visiting Users#edit page" do
				before { visit edit_user_path(other_user) }
				it { should_not have_selector("title", text: "Edit user") }
			end

			describe "invoking a PUT request to Users#update" do
				before { put user_path(other_user) }
				specify { response.should redirect_to(root_path) }
			end
		end

		describe "as non-admin user" do
			let(:user) { FactoryGirl.create(:user) }
			let(:non_admin) { FactoryGirl.create(:user) }

			before { sign_in(non_admin) }

			describe "invoking a delete request (Users#destroy action) " do
				before { delete user_path(user) }
				specify { response.should redirect_to(root_path) }
			end
		end
	end
end
