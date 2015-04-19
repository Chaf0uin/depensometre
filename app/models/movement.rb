class Movement < ActiveRecord::Base
	validates :name, presence: true
	validates :category, presence: true
	validates :amount, presence: true

	scope :category, -> (category) { where category: category }
	scope :user_id, -> (user) { where user_id: user }
	scope :movementType, -> (movementType) { where movementType: movementType }
	#scope :date, -> (year) { where('extract(year  from date) = ?', year) }
	#scope :date_year_month, -> (year, month) { where("strftime('%Y', date) = ? and strftime('%m', date) = ?", year, month) }
	scope :date_year_month, -> (year, month) { where("extract(year from date) = ? and extract(month from date) = ?", year, month) }

	# filterrific(
	#     available_filters: [
	#     	:date_year_month
	#     ]
	# )


	def self.find_all_by_date(yr, mth, user)
		if (yr.nil? || mth.nil?)
			Movement.date_year_month(Time.now.strftime("%Y"), Time.now.strftime("%m")).user_id(user)
		else
			Movement.date_year_month(yr, mth).user_id(user)
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

	def self.find_all_years_by_user(user_id)

		@years = []

		Movement.user_id(user_id).pluck(:date).each do | year |
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

	def self.find_all_months_by_user(user_id)

		@months = []

		Movement.user_id(user_id).pluck(:date).each do | month |
			@months << month.strftime("%m")
		end

		@months = @months.uniq.sort_by(&:to_i)
	end

	def self.compute_total(movements)
		@total = 0
		movements.order(:date).each do |movement|
			if (movement.movementType)
				@total = @total - movement.amount
			else 	
				@total = @total + movement.amount
			end	
		end	

		return @total
	end	

	def self.compute_cumulative_list(movements)

		sorted_movements = movements.order(:date);

		signed_movements = Array.new

		sorted_movements.each do |movement|
			m = Hash.new
		 	m[:date] = movement.date
		 	if (movement.movementType)
		 		m[:amount] = 0 - movement.amount
		 	else
		 		m[:amount] = 0 + movement.amount
		 	end

			signed_movements.push(m)
		 end



		grouped_movements = Hash.new(0)
		signed_movements.each do |movement|
			grouped_movements[movement[:date]] += movement[:amount]
		end

		cumulated_movements = Array.new()
		total = 0

		grouped_movements.each do |key, value|
		 	total += value
			cumulated_movements.push([key, total])
		end

		return cumulated_movements

	end	

	def self.find_all_names(user)
		Movement.user_id(user).pluck(:name).uniq
	end	

	def self.find_all_categories(user)
		Movement.user_id(user).pluck(:category).uniq
	end	
                   
end
