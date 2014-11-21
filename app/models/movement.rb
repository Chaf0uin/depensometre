class Movement < ActiveRecord::Base
	validates :name, presence: true
	validates :category, presence: true
	validates :amount, presence: true
                   
end
