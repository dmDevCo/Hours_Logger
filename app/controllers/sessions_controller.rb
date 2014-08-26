class SessionsController < ApplicationController

  def new  
    unless flash[:notice]
		flash[:notice] = {:class => "login_notice", :body => "To track your time, I need to know who you are."}
	end
	
	if flash[:notice][:body] == "Nice to meet you, I am Hours Logger."
		flash[:notice] = {:class => "login_notice", :body => "To track your time, I need to know who you are."}
	end
  end

  
  
  def create
    @user = User.find_by_name(params[:name])
	if @user && @user.authenticate(params[:password])
	set_user_cookie(@user)
      redirect_to root_url
  	else
        flash[:notice] = {:class => "invalid", :body => "Invalid user/password combination"}
    	redirect_to login_path
  	end
  end

  
  
  
  def destroy
  	cookies[:user_id] = nil
  	flash[:notice] = {:class => "logged_out", :body => "Goodbye"}
  	redirect_to login_url
  end
end
