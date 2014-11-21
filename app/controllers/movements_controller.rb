class MovementsController < ApplicationController

  skip_before_filter :verify_authenticity_token

	def new
		@movement = Movement.new
    end

    def create
	  @movement = Movement.new(movement_params)

    respond_to do |format|
      if @movement.save
        format.html { redirect_to @movement }
        format.json { render json: @movement, status: :created }
        format.xml { render xml: @movement, status: :created }
      else
        format.html { render 'new' }
        format.json { render json: @movement.errors, status: :unprocessable_entity }
        format.xml { render xml: @movement.errors, status: :unprocessable_entity }
      end
    end
	 

	end

	def show
	  puts Movement.find(params[:id])	
  	  @movement = Movement.find(params[:id])
        respond_to do |format|
          format.json { render json: @movement }
          format.xml { render xml: @movement }
          format.html # show.html.erb
        end
	end

	def index
  	  @movements = Movement.all
      
      respond_to do |format|
        format.json { render json: @movements }
        format.xml { render xml: @movements }
        format.html # index.html.erb
      end
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
