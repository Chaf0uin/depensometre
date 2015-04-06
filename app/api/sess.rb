class Sess < Grape::API
  resource :session do

    desc "Authenticate user and return user object / access token"
    params do
      requires :email, type: String, desc: "User email"
      requires :password, type: String, desc: "User Password"
    end

    post do
      email = params[:email]
      password = params[:password]

      if email.nil? or password.nil?
        error!({error_code: 404, error_message: "Invalid Email or Password."},401)
        return
      end

      user = User.where(email: email.downcase).first
      if user.nil?
        error!({error_code: 404, error_message: "Invalid Email or Password."},401)
        return
      end

      if !user.valid_password?(password)
        error!({error_code: 404, error_message: "Invalid Email or Password."},401)
        return
      else
        #user.ensure_authentication_token!
        user.ensure_authentication_token
        user.save
        {status: 'ok', token: user.authentication_token}.to_json
        #{status: 'ok', token: 'TROLOLO'}.to_json
      end
    end


  end
end