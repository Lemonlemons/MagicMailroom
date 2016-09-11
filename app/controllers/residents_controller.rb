class ResidentsController < ApplicationController
  before_action :authenticate_user!
  before_action :detect_no_company
  before_action :set_resident, only: [:show, :edit, :update, :destroy, :reregister]

  # GET /residents
  def index
    @residents = current_user.company.residents
  end

  # GET /residents/new
  def new
    @resident = Resident.new
  end

  # GET /residents/1/edit
  def edit
  end

  def reregister
    if @resident.opted_out?
      if @resident.opt_in
        redirect_to residents_path, notice: 'Resident re-registered for notifications'
      else
        redirect_to residents_path, notice: 'Resident re-registered unsucccessful'
      end
    else
      if @resident.opt_out
        redirect_to residents_path, notice: 'Resident unregistered for notifications'
      else
        redirect_to residents_path, notice: 'Resident unregistered unsucccessful'
      end
    end
  end

  # POST /residents
  def create
    @resident = Resident.new(resident_params)
    @resident.company_id = current_user.company_id

    if @resident.save
      if NotificationMailer.welcome_email(@resident, @resident.company).deliver_later
        redirect_to residents_path, notice: 'Resident was successfully created.'
      else
        redirect_to residents_path, notice: 'Resident email not successfully sent'
      end
    else
      render :new
    end
  end

  # PATCH/PUT /residents/1
  def update
    if @resident.update(resident_params)
      redirect_to residents_path, notice: 'Resident was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /residents/1
  def destroy
    @resident.destroy
    redirect_to residents_url, notice: 'Resident was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_resident
      @resident = Resident.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def resident_params
      params.fetch(:resident, {}).permit(:name, :apartment_number, :phone, :email)
    end

    def detect_no_company
      if current_user != nil && current_user.company_id == nil
        redirect_to "/users/edit"
      elsif current_user != nil && current_user.company_id != nil
        @current_company = current_user.company
      end
  	end
end
