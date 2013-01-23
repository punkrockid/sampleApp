require 'spec_helper'

describe User do
	before do
		@user = User.new(name: "usr", email: "tst_m@il.co.uk",
					password: "psswrd", password_confirmation: "psswrd")
	end

	subject { @user }
	it { should respond_to(:name) }
	it { should respond_to(:email) }
	it { should respond_to(:password_digest) }
	it { should respond_to(:password) }
	it { should respond_to(:password_confirmation) }
	it { should respond_to(:authenticate) }
	it { should respond_to(:remember_token) }
	it { should respond_to(:admin) }
	it { should respond_to(:microposts) }
	it { should respond_to(:feed) }

	it { should be_valid }
	it { should_not be_admin }

	describe "accessible attributes" do
		it "admin should not be accessible" do
			expect do
				User.new(admin: "1")
			end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
		end
	end

	describe "when name is not present" do
		before { @user.name=" " }
		it { should_not be_valid }
	end

	describe "when email is not present" do
		before { @user.email=" " }
		it { should_not be_valid }
	end

	describe "when name is too long" do
		before { @user.name="x"*51 }
		it { should_not be_valid }
	end

	describe "when email format is invalid" do
		it "should be invalid" do
			addresses=%w[user@any,com user_at_any.com, example@user.]
			addresses.each do |invalid_adrs|
				@user.email=invalid_adrs
				@user.should_not be_valid
			end
		end
	end

	describe "when email format is valid" do
		it "should be valid" do
			addresses=%w[user@any.com uSR@any.org, name@user.jp a+b@china.cn]
			addresses.each do |valid_adrs|
				@user.email=valid_adrs
				@user.should be_valid
			end
		end
	end

	describe "when email address is already taken" do
		before do
		  	dup_user=@user.dup
		  	dup_user.save
		end
		it { should_not be_valid }
	end

	describe "when password is not present" do
		before { @user.password = @user.password_confirmation = " " }
		it { should_not be_valid }
	end

	describe "when password doesn't match confirmation" do
		before { @user.password_confirmation="mismatch" }
		it { should_not be_valid }
	end

	describe "when password confirmation is nil" do
		before { @user.password_confirmation=nil }
		it { should_not be_valid }
	end

	describe "when password is too short" do
		before { @user.password=@user.password_confirmation="x"*5 }
		it { should_not be_valid }
	end

	describe "return value of authenticate method" do
		before { @user.save }
		let(:found_user) { User.find_by_email(@user.email) }

		describe "with valid password" do
			it { should == found_user.authenticate(@user.password) }
		end

		describe "with invalid password" do
			let(:user_invalid_pswd) { found_user.authenticate("invalid") }
			it { should_not == user_invalid_pswd }
			specify { user_invalid_pswd.should be_false }
		end
	end

	describe "remember token" do
		before { @user.save }
		its(:remember_token) { should_not be_blank }
	end

	describe "microposts associations" do
		before { @user.save }
		let!(:older_post) do
			FactoryGirl.create(:micropost, user: @user, created_at: 1.day.ago)
		end
		let!(:newer_post) do
			FactoryGirl.create(:micropost, user: @user, created_at: 1.hour.ago)
		end

		it "should have the right microposts in the right order" do
			@user.microposts.should==[newer_post, older_post]
		end

		it "should destroy associated microposts" do
			microposts=@user.microposts
			@user.destroy
			microposts.each do |post|
				Micropost.find_by_id(post.id).should be_nil
			end
		end

		describe "status" do
			let(:unfollowed_post) do
				FactoryGirl.create(:micropost, user: FactoryGirl.create(:user))
			end
			its(:feed) { should include(older_post) }
			its(:feed) { should include(newer_post) }
			its(:feed) { should_not include(unfollowed_post) }
		end
	end
end
