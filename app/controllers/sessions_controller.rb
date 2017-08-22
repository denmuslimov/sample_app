class SessionsController < ApplicationController
	def new
	end

	def create
		# @user -- instance variable; @user can be accessed in the integration test
		# user -- normal (non-instance) variable; user -- no access from the integration test
		@user = User.find_by(email: params[:session][:email].downcase)

		if @user && @user.authenticate(params[:session][:password])
			log_in @user			# Use helper function to remember user (session)
			# Use cookie to remember user IF the check box "remember_me" is checked
			params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
			
			redirect_to @user		# Redirect to the user's show page
		else
			# Create an error message that will last ONLY one screen
			flash.now[:danger] = 'Invalid email/password combination'
			# "render" doesn't count as "one screen" --> flash[] will stay one
			# one more redirect
			render 'new'
		end
	end

	def destroy
		# Log out only if there was a log in to avoid FAILS
		log_out if logged_in?
		redirect_to root_url
	end
end
