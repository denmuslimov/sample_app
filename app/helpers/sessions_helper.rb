module SessionsHelper

	# Log in the given user
	def log_in (user)
		session[:user_id] = user.id
	end

	# If <<@current_user>> exists --> Return <<@current_user>>
	# ELSE Rerutn <<User.find_by(id: session[:user_id])>>
	def current_user
		@current_user ||= User.find_by(id: session[:user_id])
	end

	# Return TRUE if the user is loged in adn FALSE otherwise
	def logged_in?
		!current_user.nil?
	end

	# Logs out the current user
	def log_out
		session.delete(:user_id)
		@current_user = nil
	end

end
