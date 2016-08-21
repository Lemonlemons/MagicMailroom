class CompaniesController < ApplicationController
  before_action :authenticate_user!
  before_action :detect_no_company, except: [:new, :create]
  before_action :set_company, only: [:edit, :update, :destroy]

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
    @company.email_subject_line = @company.name + ' has a delivery waiting for you in the office'
    @company.email_title = "You have a delivery waiting for you in the office!"
    @company.email_body = "There is a delivery waiting for you down in the office! Come pick it up anytime during office hours and one of our staff members would be happy to retrieve it for you. Thanks and have a great day!"

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
      redirect_to edit_company_path(@company), notice: 'Company was successfully updated.'
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
      @company = current_user.company.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def company_params
      params.fetch(:company, {}).permit(:name, :email_subject_line, :email_title, :email_body)
    end

  	def detect_no_company
      if current_user != nil && current_user.company_id == nil
        redirect_to "/users/edit"
      elsif current_user != nil && current_user.company_id != nil
        @current_company = current_user.company
      end
  	end
end
