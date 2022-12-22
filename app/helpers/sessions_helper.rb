module SessionsHelper
  def log_in(user)
    session[:user_id] = user.id 
  end
  
  
  def remember(user)
      user.remember
      cookies.permanent.encrypted[:user_id] = user.id
      cookies.permanent[:remember_token] = user.remember_token

  end
  
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
  
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end
    
  def current_user 
    if (user_id = session[:user_id]) # if session with user_is exists
      @current_user ||= User.find_by(id: user_id) # using this for not hitting the database 2much
    elsif (user_id = cookies.encrypted[:user_id])
      user = User.find_by(id: user_id)
      if user&.authentificated?(:remember, cookies[:remember_token])
        log_in(user)
        @current_user = user
      end
    end
  end
  
  def logged_in?
    !current_user.nil?
  end
  
  def current_user?(user) # returns true is the given user is current user
    user && user == current_user
  end
  
  def redirect_back_or(default) # redirects to stored location (user friendly)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end
  
  def store_location # stores the last url wanted to be accessed
      session[:forwarding_url] = request.original_url if request.get?    
  end
  
end
