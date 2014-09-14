class Notifier < ActionMailer::Base
  default from: "mail.HoursLogger@gmail.com"

  
  def timer_running(user, time_started)
    @user = user
	@time_started = time_started
    mail to: user.email
  end
end
