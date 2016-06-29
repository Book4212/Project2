class Subject < ActiveRecord::Base
	has_many :secs

	scope :search, -> (search) { where("subject_Name LIKE ?", "%#{search}%") }
end
