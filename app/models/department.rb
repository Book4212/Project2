class Department < ActiveRecord::Base
  belongs_to :faculty
  has_many :teacher
  has_many :student
end
