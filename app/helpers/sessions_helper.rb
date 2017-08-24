module SessionsHelper

	# Log in the given user
	def log_in (user)
		session[:user_id] = user.id
	end

	# Ramembers a user in a persistent session
	def remember(user)
		user.remember
		cookies.permanent.signed[:user_id] = user.id
		cookies.permanent[:remember_token] = user.remember_token
	end

	# Return TRUE if the given user is the current user
	def current_user?(user)
		user == current_user
	end

	# Return the user corresponding to the rememberd token cookie
	# > {If <<@current_user>> exists --> Return <<@current_user>>
	# >  ELSE Rerutn <<User.find_by(id: session[:user_id])>>}
	def current_user
		if (user_id = session[:user_id])
			# Authenticate by "session"
			@current_user ||= User.find_by(id: user_id)
		elsif (user_id = cookies.signed[:user_id])
#			raise		# Raise an exception to see if the test will cantch that
			# Authenticate by "cookie"
			user = User.find_by(id: user_id)
			if user && user.authenticated?(:remember, cookies[:remember_token])
				log_in user
				@current_user = user
			end
		end
	end

	# Return TRUE if the user is loged in adn FALSE otherwise
	def logged_in?
		!(current_user.nil?)
	end

	# Forget a persistent session
	def forget(user)
		user.forget
		cookies.delete(:user_id)
		cookies.delete(:remember_token)
	end

	# Logs out the current user
	def log_out
		forget(current_user)
		session.delete(:user_id)
		@current_user = nil
	end

	# Redirects to stored location (or to the default).
	def redirect_back_or(default)
		# Redirect happen only AFTER the end of the function
		redirect_to(session[:forwarding_url] || default)
		session.delete(:forwarding_url)
	end

	# Store the URL trying to be accessed.
	def store_location
		# "Request" of the original page
		session[:forwarding_url] = request.original_url if request.get?
	end

end
