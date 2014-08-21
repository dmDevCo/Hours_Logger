class SessionsController < ApplicationController
  def new  
    if !cookies[:user_id].nil? && current_user
      redirect_to home_path
    else
      flash[:notice] = {:class => "login_notice", :body => "To track your time, I need to know who you are."}
    end
  end

  def create
    @user = User.authenticate(params[:name], params[:password])
  	if @user.present?
      set_user_cookie(@user)
    	redirect_to root_url, notice: "Nice to meet you, I am Hours Logger."
  	else
      # flash[:notice] = {:class => "invalid", :body => "Invalid user/password combination"}
    	redirect_to login_path, error: "Invalid user/password combination"
  	end
  end

  def destroy
  	cookies[:user_id] = nil
  	flash[:notice] = {:class => "logged_out", :body => "Goodbye"}
  	redirect_to login_url
  end
end
