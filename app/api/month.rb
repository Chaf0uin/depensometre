class Month < Grape::API
  resource :months do

    desc "list"
    get do
      access_token = headers["Access-Token"]
      user = User.find_by_authentication_token(access_token)

      movements = Movement.find_all_months_by_user(user.id)

      select = Array.new
      months.each do |month|
        m = Hash["month", month]
        select.push(m)
      end

      return select
    end

  end
end