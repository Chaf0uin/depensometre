class Movement < ActiveRecord::Base
	validates :name, presence: true
	validates :category, presence: true
	validates :amount, presence: true

	scope :category, -> (category) { where category: category }
	scope :movementType, -> (movementType) { where movementType: movementType }
	#scope :date, -> (year) { where('extract(year  from date) = ?', year) }
	scope :date_year_month, -> (year, month) { where("strftime('%Y', date) = ? and strftime('%m', date) = ?", year, month) }

	attr_accessor :signed_amount

	filterrific(
	    available_filters: [
	    	:date_year_month
	    ]
	)


	def self.find_all_by_date(year, month)
		if (year.nil? || month.nil?) 
			Movement.date_year_month(Time.now.strftime("%Y"), Time.now.strftime("%m")).order(:date)
		else
			Movement.date_year_month(year, month).order(:date)
		end

	end

	def self.find_all_years
		#Model.select("distinct(extract(year from date))")
		#Movement.select("strftime('%Y', date)")

		@years = []

		Movement.pluck(:date).each do | year |
		    @years << year.strftime("%Y")
		end

		@years = @years.uniq
	end	

	def self.find_all_months
		#Model.select("distinct(extract(month from date))")
		#Movement.select("strftime('%m', date)")

		@months = []

		Movement.pluck(:date).each do | month |
		    @months << month.strftime("%m")
		end

		@months = @months.uniq.sort_by(&:to_i)
	end	

	def self.compute_total(movements)
		@total = 0
		movements.each do |movement|
			if (movement.movementType)
				@total = @total - movement.amount
			else 	
				@total = @total + movement.amount
			end	
		end	

		return @total
	end	

	def self.compute_cumulative_list(movements)
		cumulative_list = Array.new

		movements.each do |movement|
			m = Hash.new
			m[:date] = movement.date
			if (movement.movementType)
				m[:amount] = 0 - movement.amount
			else
				m[:amount] = 0 + movement.amount
			end

			cumulative_list.push(m)
		end

		totals = Hash.new(0)
		cumulative_list.each do |movement|
			totals[movement[:date]] += movement[:amount]
		end

		cumul = Array.new()
		total = 0

		totals.each do |key, value|
			total += value
			cumul.push([key, total])
		end

		return cumul

	end	
                   
end
