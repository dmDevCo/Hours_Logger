
class TimeCardsController < ApplicationController
  before_action :set_time_card, only: [:show, :edit, :update, :destroy]
  before_action :set_zone, only: [:month, :year, :all, :edit, :stats]
  
  RANDOM_QUOTES = ["Let's get to work.", "The best time to get it done is NOW!", "Hard work PAYS OFF!", "MORE GRINDING = MORE $$$", "Sleep is for people who are BROKE!", "Ridiculous, SICKENING Work Ethic ... #RSWE", "While you are sleeping, someone else is trying to beat you."]
  
  
  
  
  
  def index
	unless flash[:notice]
  		flash[:notice] = {:class => "login_notice", :body => RANDOM_QUOTES[Random.rand(7)] }
  	end
	
  	if notice
  		if flash[:notice][:body] == "To track your time, I need to know who you are."
  			flash[:notice] = {:class => "login_notice", :body => RANDOM_QUOTES[Random.rand(7)] }
  		end
  	end
  
	if !cookies[:user_id].present?
		flash[:notice] = {:class => "login_notice", :body => "To track your time, I need to know who you are."}
		redirect_to login_path
	end
  
	@time_card = TimeCard.new
  end
  
  
  
  def email_timer 
	@user = User.find_by_name(params[:id])
	if @user
		set_user_cookie(@user)
	end
	
    redirect_to root_url
  end
  
  
  
  
  def stats
	@total_hours = 0
	@date = Time.new
	@client = "New"
	@time = "stats"
	@month_selected_1 = 0
	@year_selected_1 = 0

	
	if !params[:time].present?
		flash[:notice] = nil
		
		beg_of_week = Time.now.at_end_of_week-8.day+1
		end_of_week = Time.now.at_end_of_week-1.day+1
		
		if params[:time_selected].present?
			beg_of_week = params[:time_selected]
			beg_of_week = beg_of_week.to_datetime
			end_of_week = params[:time_selected]
			end_of_week = (end_of_week.to_datetime+6.day+1)
			@time_selected = beg_of_week
		end

		beg_of_week = (beg_of_week-7.hours)
		end_of_week = (end_of_week-7.hours+48.hours)
		
		@time_cards = current_user.time_cards.where(time_started: beg_of_week .. end_of_week).order("date DESC")
	end
	
	
	if params[:time] == "stats"
		flash[:notice] = nil
		
		beg_of_week = Time.now.at_end_of_week-8.day+1
		end_of_week = Time.now.at_end_of_week-1.day+1
		
		if params[:time_selected].present?
			beg_of_week = params[:time_selected]
			beg_of_week = beg_of_week.to_datetime
			end_of_week = params[:time_selected]
			end_of_week = (end_of_week.to_datetime+6.day+1)
			@time_selected = beg_of_week
		end
		
		beg_of_week = (beg_of_week-7.hours)
		end_of_week = (end_of_week-7.hours+24.hours)
		
		@time_cards = current_user.time_cards.where(time_started: beg_of_week .. end_of_week).order("date DESC")
		
	end
	
	
	
	
	if params[:time] == "month"
	
		beg_of_month = Time.now.at_beginning_of_month
		end_of_month = Time.now.at_end_of_month
		
		if params[:time_selected].present?
			beg_of_month = params[:time_selected]
			beg_of_month = beg_of_month.to_datetime
			end_of_month = params[:time_selected]
			end_of_month = (end_of_month.to_datetime+1.month)
			@month_selected = beg_of_month
		end
	
		@time_cards = current_user.time_cards.where(date: beg_of_month .. end_of_month).order("date DESC")
	end
	
	
	
	

  if params[:time] == "year"
	
		beg_of_year = Time.now.at_beginning_of_year
		end_of_year = Time.now.at_end_of_year
		
		if params[:time_selected].present?
			beg_of_year = params[:time_selected]
			beg_of_year = beg_of_year.to_datetime
			end_of_year = params[:time_selected]
			end_of_year = (end_of_year.to_datetime+1.year)
			@year_selected = beg_of_year
		end
		
		@time_cards = current_user.time_cards.where(date: beg_of_year .. end_of_year).order("date DESC")
	end
		clients = @time_cards
		@clients = clients.uniq_by{|s| s.client}
		
	if params[:client].present?
		if params[:client] != "all"
			@time_cards = @time_cards.where(client: params[:client])
		end
	end
		
	
	
	# Total the Hours
	@time_cards.each do |time_card|
		@total_hours = (@total_hours+((time_card.time_stopped - time_card.time_started)/3600))
	end
	
  end
  
  
  
  
  
  
  
  def show
  end


  def new
    @time_card = TimeCard.new
  end

  
  def edit
  end

  def email
	@user = current_user
	@time_started = cookies[:start_time]
	Notifier.timer_running(@user, @time_started).deliver
	
	
    respond_to do |format|
      format.json { render json: "success"}
    end
  end
 
  
  
  def create
    # Store the current start and stop time in the users time card
	
	
    now = Time.now
    @time_card = TimeCard.new(time_card_params)
    @time_card.user_id = cookies[:user_id]
	
  	@time_card.time_stopped = now
  	@time_card.time_started= (now-params[:total_seconds].to_i)
  	@time_card.date = Time.now.in_time_zone("Pacific Time (US & Canada)").to_date

	if @time_card.client == ""
		@time_card.client = "No Client"
	end
	@time_card.client = @time_card.client.downcase
	
	if params[:end_time] == "true"
		utc_stop = Time.new(params[:time_card]["date(1i)"].to_i,
							params[:time_card]["date(2i)"].to_i,
							params[:time_card]["date(3i)"].to_i, 
							params[:time_card]["time_stopped(4i)"],
							params[:time_card]["time_stopped(5i)"],
							0, "-07:00")
							
		utc_stop = utc_stop.in_time_zone("UTC")
		@time_card.time_stopped = utc_stop
		
		utc_start = params[:start_time]
		utc_start = utc_start.to_datetime.in_time_zone("UTC")
		@time_card.time_started = utc_start
		
	end
	
    respond_to do |format|
      if @time_card.save
		flash[:notice] = {:class => "login_notice", :body => "Got it!  I logged your hours."}
        format.html { redirect_to root_url}
        format.json { render action: 'show', status: :created, location: @time_card }
      else
        format.html { render action: 'new' }
        format.json { render json: @time_card.errors, status: :unprocessable_entity }
      end
    end
  end


  
  
  
  def update
    respond_to do |format|
  		utc_start = Time.new(params[:time_card]["date(1i)"].to_i,
							params[:time_card]["date(2i)"].to_i,
							params[:time_card]["date(3i)"].to_i, 
							params[:time_card]["time_started(4i)"], 
							params[:time_card]["time_started(5i)"],
							0, "-07:00")
							   
  		utc_stop = Time.new(params[:time_card]["date(1i)"].to_i,
							params[:time_card]["date(2i)"].to_i,
							params[:time_card]["date(3i)"].to_i, 
							params[:time_card]["time_stopped(4i)"],
							params[:time_card]["time_stopped(5i)"],
							0, "-07:00")
		
		
  		utc_start = utc_start.in_time_zone("UTC")
  		utc_stop = utc_stop.in_time_zone("UTC")
  		date = Date.new(params[:time_card]["date(1i)"].to_i, params[:time_card]["date(2i)"].to_i, params[:time_card]["date(3i)"].to_i)
		
		
		client = params[:time_card]["client"].downcase

		if params[:time_card]["client"] == ""
		 client = "no client"
		end
		
		
  	  if @time_card.update(time_started: utc_start, time_stopped: utc_stop, message: params[:time_card]["message"], date: date, client: client )
  		  flash[:notice] = {:class => "login_notice", :body => "Successfully updated!"}
        format.html { redirect_to "/" }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @time_card.errors, status: :unprocessable_entity }
      end
    end
  end
 

 
 
 
 
  def destroy
    @time_card.destroy
    respond_to do |format|
      format.html { redirect_to time_cards_by_path(:stats) }
      format.json { head :no_content } # TODO SUCCESS => TRUE {success: true}
    end
  end

  
  
  
  
  
  
private
  
  def set_zone
    Time.zone = "Pacific Time (US & Canada)"
  end
  

  def set_time_card
    @time_card = TimeCard.find(params[:id])
  end


  def time_card_params
    params.require(:time_card).permit(:time_started, :time_stopped, :client, :date, :message)
  end
  
end

