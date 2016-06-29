class Teach < ActiveRecord::Base
  belongs_to :user
  belongs_to :sec
end
