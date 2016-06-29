class Teacher < ActiveRecord::Base
  belongs_to :user
  belongs_to :department

  # VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
	# validates :facebook, presence: true, length:{ maximum: 255 }, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive:false }
	
end
