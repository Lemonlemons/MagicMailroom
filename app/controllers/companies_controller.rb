class CompaniesController < ApplicationController
  before_action :authenticate_user!
  before_action :detect_no_company, except: [:new, :create]
  before_action :set_company, only: [:edit, :update, :destroy]

  # GET /companies
  def index
    @companies = Company.all
  end

  # GET /companies/new
  def new
    @company = Company.new
  end

  # GET /companies/1/edit
  def edit
  end

  # POST /companies
  def create
    @company = Company.new(company_params)
    @company.company_code = SecureRandom.uuid

    if @company.save
      current_user.company_id = @company.id
      if current_user.save
        redirect_to root_path, notice: 'Company was successfully created.'
      else
        puts "error"
      end
    else
      render :new
    end
  end

  # PATCH/PUT /companies/1
  def update
    if @company.update(company_params)
      redirect_to @company, notice: 'Company was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /companies/1
  def destroy
    @company.destroy
    format.html { redirect_to companies_url, notice: 'Company was successfully destroyed.' }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_company
      @company = Company.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def company_params
      params.fetch(:company, {}).permit(:name)
    end

  	def detect_no_company
      if current_user != nil && current_user.company_id == nil
        redirect_to "/users/edit"
      elsif current_user != nil && current_user.company_id != nil
        @current_company = current_user.company
      end
  	end
end
