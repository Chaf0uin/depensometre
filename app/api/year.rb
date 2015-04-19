class Year < Grape::API
  resource :years do

    desc "list"
    get do
      access_token = headers["Access-Token"]
      user = User.find_by_authentication_token(access_token)

      years = Movement.find_all_years_by_user(user.id)

      select = Array.new
      years.each do |year|
        y = Hash["year", year]
        select.push(y)
      end

      return select
    end

  end
end