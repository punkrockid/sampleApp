class SessionsController < ApplicationController
	def new
	end

	def create
		user=User.find_by_email(params[:session][:email])
		if (user && user.authenticate(params[:session][:password]))
			sign_in user
			redirect_back_or user
		else
			flash.now[:error] = "Invalid password or email"
			render "new"
		end
	end

	def destroy
		sign_out
		redirect_to root_path
		flash[:success] = "You have signed out"
	end
end
