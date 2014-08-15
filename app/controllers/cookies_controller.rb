class CookiesController < ApplicationController
  def new
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
	flash[:notice] = {:class => "logged_out", :body => "Logged out"}
	redirect_to login_url
  end
end
