class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  # before_action :require_user # TODO turn this off for the controller actions that need public access. 
  
  private
  
  def require_user
    unless current_user.present?
      redirect_to login_path, error: "You must login!"
    end
  end
  helper_method :require_user
  
  
  def current_user
    @user ||= User.find(cookies[:user_id])
  end
  helper_method :current_user
  
  
  def set_user_cookie(user)
  	cookies[:user_id] = {
    	value: user.id,
    	expires: 1.year.from_now.utc
  	}
  end
  helper_method :set_user_cookie
  
end
