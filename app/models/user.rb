class User < ActiveRecord::Base
	attr_accessible :email, :name, :password, :password_confirmation
	has_secure_password
	has_many :microposts, dependent: :destroy

	before_save { |user| user.email = user.email.downcase }
	before_save :create_remember_token

	validates :name, presence: true, length: { maximum:50 }
	VALID_EMAIL_REGEXP=/[\w+\-.]+@[a-z\d\-.]+\.[a-z]+/i
	
	validates :email, presence: true, format: { with: VALID_EMAIL_REGEXP },
	uniqueness: { case_sensitive: false }

	validates :password, length: { minimum:6 }
	validates :password_confirmation, presence: true

	def feed
		#proto feed
		Micropost.where("user_id=?", id)
	end

	private 
		def create_remember_token
			self.remember_token = SecureRandom.urlsafe_base64
		end
end
