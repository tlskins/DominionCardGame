module LoginMacros

  # Logs in a test user using CRUD commands for controller testing
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

  # Signs in a test user for RSpec feature testing
  def sign_in(user)
    visit root_path
    click_link "Log in"
    fill_in "Email", :with => user.email
    fill_in "Password", :with => user.password
    click_button "Log in"
  end

end
