class SessionsController < ApplicationController
	def new
	end

	def create
		user = User.find_by(email: params[:session][:email].downcase)
		if user && user.authenticate(params[:session][:password])
			# Log the user in and redirect to the user's show page
			log_in user 		# Use helper function
			redirect_to user
		else
			# Create an error message that will last ONLY one screen
			flash.now[:danger] = 'Invalid email/password combination'
			# "render" doesn't count as "one screen" --> flash[] will stay one
			# one more redirect
			render 'new'
		end
	end

	def destroy
		log_out
		redirect_to root_url
	end
end
