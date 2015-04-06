class MovementsController < ApplicationController

  skip_before_filter :verify_authenticity_token
  before_action :authenticate_user!

  def index
      @movements = Movement.find_all_by_date(params[:year], params[:month], current_user.id)
      if (params[:year].nil?)
        @selected_year = Time.now.strftime("%Y")
      else
        @selected_year = params[:year]
      end  

      if (params[:month].nil?)
        @selected_month = Time.now.strftime("%m")
      else
        @selected_month = params[:month]
      end   

      @total = Movement.compute_total(@movements)
      @cumulative_list = Movement.compute_cumulative_list(@movements)
  end


	def new
		@movement = Movement.new
  end

    def create
	  @movement = Movement.new(movement_params)
    @movement.user_id = current_user.id

    if @movement.save
      redirect_to @movement
    else
      render 'new'
    end

	end

	def show
    @movement = Movement.find(params[:id])
	end

	
	def destroy
  	  @movement = Movement.find(params[:id])

      respond_to do |format|
      if @movement.destroy
        format.html { redirect_to movements_path }
        format.json { head :no_content, status: :ok }
        format.xml { head :no_content, status: :ok }
      else
        format.html {}
        format.json { render json: @movement.errors, status: :unprocessable_entity }
        format.xml { render xml: @movement.errors, status: :unprocessable_entity }
      end
    end

	end

	def edit
  	  @movement = Movement.find(params[:id])
	end

	def update
  	  @movement = Movement.find(params[:id])
 
  	  if @movement.update(movement_params)
    	redirect_to @movement
  	  else
      	render 'edit'
  	  end
    end

	private
  	  def movement_params
  	  	if params[:movement][:movementType] == "output"
  	  		params[:movement][:movementType] = true
  	  	else
  	  		params[:movement][:movementType] = false
  	  	end		

        params.require(:movement).permit(:name, :category, :amount, :movementType, :date)
      end
end
