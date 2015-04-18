class Mvnt < Grape::API
  resource :movements do

    desc "list"
    get do
      access_token = headers["Access-Token"]
      user = User.find_by_authentication_token(access_token)
      year = headers["Year"]
      month = headers["Month"]
      Movement.find_all_by_date(year, month, user.id).order(date: :desc)
    end

    desc "create a new movement"
    params do
      requires :name, type: String
      requires :category, type:String
      requires :amount, type:BigDecimal
      requires :movementType, type:Boolean
      requires :date, type:String
    end
    post do
      access_token = headers["Access-Token"]
      user = User.find_by_authentication_token(access_token)
      date = params[:date].to_datetime
      Movement.create!({
        user_id: user.id,
        name:params[:name],
        category:params[:category],
        amount:params[:amount],
        movementType:params[:movementType],
        date: date
      })
    end

    desc "delete a movement"
    params do
      requires :id, type: Integer
    end
    delete ':id' do
      Movement.find(params[:id]).destroy!
    end

    desc "update a movement"
    params do
      requires :name, type: String
      requires :category, type:String
      requires :amount, type:BigDecimal
      requires :movementType, type:Boolean
      requires :date, type:String
    end
    put ':id' do
      date = params[:date].to_datetime
      Movement.find(params[:id]).update({
        name:params[:name],
        category:params[:category],
        amount:params[:amount],
        movementType:params[:movementType],
        date: date
      })
    end
  end
end