class DeliveriesController < ApplicationController
  before_action :authenticate_user!
  before_action :detect_no_company
  before_action :set_delivery, only: [:show, :edit, :update, :destroy]

  # GET /deliveries
  # GET /deliveries.json
  def index
    @deliveries = current_user.company.deliveries

    # For resetting the counter cache's on the objects, I doubt I'll ever need it again
    # Company.find_each { |company| Company.reset_counters(company.id, :users) }
    # Company.find_each { |company| Company.reset_counters(company.id, :residents) }
    # User.find_each { |user| User.reset_counters(user.id, :deliveries) }
    # Resident.find_each { |resident| Resident.reset_counters(resident.id, :deliveries) }
  end

  # GET /deliveries/new
  def new
  end

  # GET /deliveries/dashboard
  def dashboard

    @user = current_user

    # Totals Chart
    @total_users = @user.company.users_count
    @total_residents = @user.company.residents_count
    @total_deliveries = @user.company.deliveries.count
    @user_deliveries = @user.deliveries_count

    # Last Month Deliveries
    @month_deliveries = @user.company.deliveries.where('deliveries.created_at >= ?', 1.months.ago)
    @month_refined = Array.new
    date_new = Date.current
    date_old = 1.months.ago.to_date
    date_new.downto date_old do |date|
      @temp = Array.new
      @temp.push(date.strftime('%Q').to_i)
      @temp.push(@month_deliveries.where(["deliveries.created_at >= ? AND deliveries.created_at <= ?", date.beginning_of_day, date.end_of_day]).count)
      @month_refined.push(@temp)
    end

    # Two Weeks Deliveries
    @two_weeks_deliveries = @month_deliveries.where('deliveries.created_at >= ?', 2.week.ago)
    @two_weeks_refined = Array.new
    date_old = 2.week.ago.to_date
    date_new.downto date_old do |date|
      @temp = Array.new
      @temp.push(date.strftime('%Q').to_i)
      @temp.push(@two_weeks_deliveries.where(["deliveries.created_at >= ? AND deliveries.created_at <= ?", date.beginning_of_day, date.end_of_day]).count)
      @two_weeks_refined.push(@temp)
    end

    # Top Notifiers
    @users = @user.company.users.order("deliveries_count DESC").limit(5)

    # Top Recipients
    @residents = @user.company.residents.order("deliveries_count DESC").limit(5)
  end

  # POST /deliveries
  def create
    apartment_numbers = []
    success = false
    message = ""
    if params[:apartment_number].include? ","
      apartment_numbers = params[:apartment_number].split(',')
    else
      apartment_numbers.push(params[:apartment_number])
    end
    apartment_numbers.each do |number|
      @resident = current_user.company.residents.find_by(apartment_number:  number)
      if @resident == nil
        redirect_to root_path, notice: "This Apartment number doesn't seem to be in our system..."
      else
        @delivery = Delivery.new()
        @delivery.resident_id = @resident.id
        @delivery.user_id = current_user.id

        if NotificationMailer.notification_email(@resident, @current_company).deliver_later
          if @delivery.save
            success = true
            message = 'Successfully Sent'
          else
            success = false
            message = "Email sent but delivery not created"
          end
        else
          success = false
          message = "Notification unsuccessfully sent"
        end
      end
    end
    if success == true
      redirect_to root_path, notice: message
    else
      render :new
    end
  end

  # PATCH/PUT /deliveries/1
  def update
    if NotificationMailer.notification_email(@delivery.resident, @current_company).deliver_later
      redirect_to deliveries_path, notice: 'Notification Resent'
    else
      redirect_to deliveries_path, notice: 'Notification Unsucccessfully Resent'
    end
  end

  # DELETE /deliveries/1
  # DELETE /deliveries/1.json
  def destroy
    @delivery.destroy
    redirect_to deliveries_url, notice: 'Delivery was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_delivery
      @delivery = current_user.deliveries.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def delivery_params
      params.fetch(:delivery, {}).permit(:apartment_number)
    end

    def detect_no_company
      if current_user != nil && current_user.company_id == nil
        redirect_to "/users/edit"
      elsif current_user != nil && current_user.company_id != nil
        @current_company = current_user.company
      end
  	end
end
