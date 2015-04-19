class API < Grape::API
  prefix 'api'
  format :json
  version 'v1', using: :path

  API::routes
  mount Sess

  rescue_from :all, backtrace: true
  # error_formatter :json, ErrorFormatter

  before do
    error!("401 Unauthorized, 401") unless authenticated
  end

  helpers do
    def warden
      env['warden']
    end

    def authenticated
      return true if warden.authenticated?
      access_token = headers["Access-Token"]
      access_token && @user = User.find_by_authentication_token(access_token)
    end

    def current_user
      warden.user || @user
    end
  end

  mount Mvnt
  mount Name
  mount Category
  mount Month
  mount Year
end
