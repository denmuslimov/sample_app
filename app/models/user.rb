class User < ApplicationRecord

	attr_accessor :remember_token

	before_save { self.email = email.downcase }
	validates :name, presence: true, length: { maximum: 50 }

	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
	validates :email, presence: true, length: { maximum: 255 }, 
					format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false}

	# Enforce validation on both: passord and its confirmation.
	has_secure_password
	# "allow_nil: true" makes UPDATE name without updating password possible.
	# New users won't be able to sign up with empty password because of "has_secure_password"
	validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

	# Returns the hash digest of the given string.
	def User.digest(string)
		# Choose the complexity of the hash (development --> min; production --> max)
		cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
		BCrypt::Password.create(string, cost: cost)
	end

	# Return a random token
	def User.new_token
		SecureRandom.urlsafe_base64
	end

	# Remember a user in the database fro use in persistent sessions
	def remember
		self.remember_token = User.new_token
		update_attribute(:remember_digest, User.digest(remember_token))
	end

	# Return TRUE if the given token matches the digest
	def authenticated?(remember_token)
		return false if remember_digest.nil?
		BCrypt::Password.new(remember_digest).is_password?(remember_token)
	end

	# Forget a user
	def forget
		update_attribute(:remember_digest, nil)
	end
	
end
