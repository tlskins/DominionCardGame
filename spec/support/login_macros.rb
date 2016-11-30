module LoginMacros

  # Logs in a test user.
  def log_in_as(user, is_feature = false, options = {})
    password    = options[:password]    || 'password'
    remember_me = options[:remember_me] || '1'
    if is_feature
      post login_path, session: { email:       user.email,
                                  password:    password,
                                  remember_me: remember_me }
    else
      session[:user_id] = user.id
    end
  end

end
