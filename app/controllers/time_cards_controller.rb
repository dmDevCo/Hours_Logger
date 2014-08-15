class TimeCardsController < ApplicationController
  before_action :set_time_card, only: [:show, :edit, :update, :destroy]

  # GET /time_cards
  # GET /time_cards.json
  def index
    @time_cards = TimeCard.all
  end
  
  def home
	@time_card = TimeCard.new
	
	user = User.find(cookies[:user_id])
		@user = user
	rescue ActiveRecord::RecordNotFound
		redirect_to "/login", :alert => "You need to sign in."
	
	

	
  end
  
  def stats
    @time_cards = TimeCard.where(user_id: cookies[:user_id]).where(created_at: (Time.now.at_end_of_week-7.day) .. Time.now.at_end_of_week)
	@count=0;
	@hours_this_week=0;
	
	@time_cards.each do |time_card|
		@hours_this_week = (@hours_this_week+((time_card.time_stopped - time_card.time_started)/3600)).round(2)
	end
  end
  
  
   def month
    @time_cards = TimeCard.where(user_id: cookies[:user_id]).where(created_at: Time.now.at_beginning_of_month .. Time.now.at_end_of_month)
	@count=0;
	@hours_this_month=0;
	
	@time_cards.each do |time_card|
		@hours_this_month = (@hours_this_month+((time_card.time_stopped - time_card.time_started)/3600))
	end
  end
  
  
  
   def year
    @time_cards = TimeCard.where(user_id: cookies[:user_id]).where(created_at: (Time.now.at_end_of_year-365.day) .. Time.now.at_end_of_year)
	@count=0;
	@hours_this_year=0;
	
	@time_cards.each do |time_card|
		@hours_this_year = (@hours_this_year+((time_card.time_stopped - time_card.time_started)/3600))
	end
  end
  
  
  
   def all
    @time_cards = TimeCard.where(user_id: cookies[:user_id])
	@count=0;
	@hours_all=0;
	
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
	@time_card.date = Date.today

    respond_to do |format|
      if @time_card.save
        format.html { redirect_to "/", notice: 'Time card was successfully created.' }
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
      if @time_card.update(time_card_params)
        format.html { redirect_to "/", notice: 'Time card was successfully updated.' }
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
      format.html { redirect_to "/stats" }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_time_card
      @time_card = TimeCard.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def time_card_params
      params.require(:time_card).permit(:time_started, :time_stopped, :date, :message)
    end
end
