class CookiesController < ApplicationController
  def new
	unless flash[:notice]
		flash[:notice] = {:class => "login_notice", :body => "To track your time, I need to know who you are."}
	end
	
	if flash[:notice][:body] == "Nice to meet you, I am Hours Logger."
		flash[:notice] = {:class => "login_notice", :body => "To track your time, I need to know who you are."}
	end
  end

  def create
	if user = User.authenticate(params[:name], params[:password])
	cookies[:user_id] = {
	:value => user.id,
	:expires => 1.year.from_now.utc
	}
	redirect_to "/"
	else
	flash[:notice] = {:class => "invalid", :body => "Invalid user/password combination"}
	redirect_to "/login"
	end
  end

  def destroy
	cookies.delete :user_id
	flash[:notice] = {:class => "logged_out", :body => "Goodbye"}
	redirect_to login_url
  end
end
