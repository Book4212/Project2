class Sec < ActiveRecord::Base
  belongs_to :subject
  has_many :checkstudy
  has_many :activity
  has_many :affectivedomain
  has_many :study
  has_many :teach
  has_many :users , through: :teach
  has_many :user , through: :study

end
