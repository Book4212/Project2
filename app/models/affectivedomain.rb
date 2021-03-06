class Affectivedomain < ActiveRecord::Base
  belongs_to :user
  belongs_to :sec

  def self.to_csv
  	CSV.generate do |csv|
  		csv << column_names
  		all.each do |affectivedomain|
  			csv << affectivedomain.attributes.values_at(*column_names)
  		end
  	end
  end
end
