
class TimeCardsController < ApplicationController
  before_action :set_time_card, only: [:show, :edit, :update, :destroy]
  before_action :set_zone, only: [:month, :year, :all, :edit, :stats]
  
  RANDOM_QUOTES = ["Let's get to work.", "The best time to get it done is NOW!", "Hard work PAYS OFF!", "MORE GRINDING = MORE $$$", "Sleep is for people who are BROKE!", "Ridiculous, SICKENING Work Ethic ... #RSWE", "While you are sleeping, someone else is trying to beat you."]

  # def index
  #   @time_cards = TimeCard.all
  # end
  
  def index
	  @time_card = TimeCard.new
	
  	unless flash[:notice]
  		flash[:notice] = {:class => "login_notice", :body => RANDOM_QUOTES[Random.rand(7)] }
  	end
	
  	if notice
  		if flash[:notice][:body] == "To track your time, I need to know who you are."
  			flash[:notice] = {:class => "login_notice", :body => RANDOM_QUOTES[Random.rand(7)] }
  		end
  	end
    
  end
  
  def stats
	  flash[:notice] = nil
    @time_cards = current_user.time_cards.where(date: (Time.now.at_end_of_week-7.day) .. Time.now.at_end_of_week)
	  @count = 0
	  @hours_this_week = 0
	
    @time_cards.each do |time_card|
  		@hours_this_week = (@hours_this_week+((time_card.time_stopped - time_card.time_started)/3600)).round(2)
  	end
  end
  
  
   def month
    @time_cards = TimeCard.where(user_id: cookies[:user_id]).where(date: Time.now.at_beginning_of_month .. Time.now.at_end_of_month)
	  @count = 0
	  @hours_this_month = 0
	
	  @time_cards.each do |time_card|
		@hours_this_month = (@hours_this_month+((time_card.time_stopped - time_card.time_started)/3600))
	end
  end
  
  
  
   def year
    @time_cards = TimeCard.where(user_id: cookies[:user_id]).where(date: (Time.now.at_end_of_year-365.day) .. Time.now.at_end_of_year)
	  @count = 0
    @hours_this_year = 0
	
	@time_cards.each do |time_card|
		@hours_this_year = (@hours_this_year+((time_card.time_stopped - time_card.time_started)/3600))
	end
  end
  
  
  
   def all
    @time_cards = TimeCard.where(user_id: cookies[:user_id])
	  @count = 0
	  @hours_all = 0
	
	@time_cards.each do |time_card|
		@hours_all = (@hours_all+((time_card.time_stopped - time_card.time_started)/3600))
	end
  end

  

  # GET /time_cards/1
  # GET /time_cards/1.json
  def show
  end

  # GET /time_cards/new
  def new
    @time_card = TimeCard.new
  end

  # GET /time_cards/1/edit
  def edit
  end

  # POST /time_cards
  # POST /time_cards.json
  def create
    now = Time.now
    @time_card = TimeCard.new(time_card_params)
    @time_card.user_id = cookies[:user_id]
	
	
  	@time_card.time_stopped = now
  	@time_card.time_started= (now-params[:total_seconds].to_i)
  	@time_card.date = Time.now.in_time_zone("Pacific Time (US & Canada)").to_date

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

  # PATCH/PUT /time_cards/1
  # PATCH/PUT /time_cards/1.json
  def update
    respond_to do |format|
  		utc_start	= Time.new(params[:time_card]["date(1i)"].to_i,params[:time_card]["date(2i)"].to_i,params[:time_card]["date(3i)"].to_i, params[:time_card]["time_started(4i)"], params[:time_card]["time_started(5i)"],0, "-07:00")
  		utc_stop	= Time.new(params[:time_card]["date(1i)"].to_i,params[:time_card]["date(2i)"].to_i,params[:time_card]["date(3i)"].to_i, params[:time_card]["time_stopped(4i)"], params[:time_card]["time_stopped(5i)"],0, "-07:00")
		
		
  		utc_start = utc_start.in_time_zone("UTC")
  		utc_stop = utc_stop.in_time_zone("UTC")
  		date = Date.new(params[:time_card]["date(1i)"].to_i, params[:time_card]["date(2i)"].to_i, params[:time_card]["date(3i)"].to_i)
	
		
  	  if @time_card.update(time_started: utc_start, time_stopped: utc_stop, message: params[:time_card]["message"], date: date )
  		  flash[:notice] = {:class => "login_notice", :body => "Successfully updated!"}
        format.html { redirect_to "/" }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @time_card.errors, status: :unprocessable_entity }
      end
    end
  end
 
  # DELETE /time_cards/1
  # DELETE /time_cards/1.json
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
  
  # Use callbacks to share common setup or constraints between actions.
  def set_time_card
    @time_card = TimeCard.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def time_card_params
    params.require(:time_card).permit(:time_started, :time_stopped, :date, :message)
  end
  
end

