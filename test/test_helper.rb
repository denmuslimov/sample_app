require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/reporters'
Minitest::Reporters.use!

class ActiveSupport::TestCase
	# Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
	fixtures :all
	include ApplicationHelper

	# Returns true if a test user is logged in.
	def is_logged_in?
		!(session[:user_id].nil?)
	end

	# Log in as a particular user (copy of the function for the controller test)
	def log_in_as(user)
		session[:user_id] = user.id
	end

	# Log out
	def log_out_now
		session.delete(:user_id)
	end

end


class ActionDispatch::IntegrationTest
	# Log in as a particular user (copy of the function for integration test)
	def log_in_as(user, password: 'password', remember_me: '1')
		post login_path, params: { session: { email: user.email, 
											  password: password, 
											  remember_me: remember_me } }
	end

end