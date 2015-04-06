class Mvnt < Grape::API
  resource :movements do

    desc "list"
    get do
      access_token = headers["Access-Token"]
      user = User.find_by_authentication_token(access_token)
      year = headers["Year"]
      month = headers["Month"]
      Movement.find_all_by_date(year, month, user.id)
    end

    desc "create a new movement"
    params do
      requires :name, type: String
      requires :address, type:String
      requires :age, type:Integer
    end
    post do
      Movement.create!({
        name:params[:name],
        address:params[:address],
        age:params[:age]
      })
    end

    desc "delete a movement"
    params do
      requires :id, type: String
    end
    delete ':id' do
      Movement.find(params[:id]).destroy!
    end

    desc "update a movement"
    params do
      requires :id, type: String
      requires :address, type:String
    end
    put ':id' do
      Movement.find(params[:id]).update({
        address:params[:address]
      })
    end
  end
end