class CompaniesController < ApplicationController
  before_action :authenticate_user!, except: [:webhooks]
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
    tier = params[:plan]
    plan = ""

    if tier == "Small"
      plan = "001"
    elsif tier == "Basic"
      plan = "002"
    elsif tier == "Premium"
      plan = "003"
    elsif tier == "Enterprise"
      plan = "004"
    end
    if @company.name != ""
      customer = Stripe::Customer.create(
        :description => @company.name,
        :email => current_user.email,
        :source  => params[:stripeToken]
      )

      stripe_subscription = customer.subscriptions.create(:plan => plan)
      @company.stripe_customer_id = customer.id
      @company.subscription_id = stripe_subscription.id
    end

    @company.tier = tier
    @company.active_until = Time.now + 1.month
    @company.company_code = SecureRandom.uuid

    if @company.save
      @company.email_subject_line = @company.name + " has a delivery waiting for you in the office"
      @company.email_title = "You have a delivery waiting for you in the office!"
      @company.email_body = "There is a delivery waiting for you down in the office! Come pick it up anytime during office hours and one of our staff members would be happy to retrieve it for you. Thanks and have a great day!"
      current_user.company_id = @company.id
      current_user.account_admin = true
      if @company.save
        if current_user.save
          redirect_to root_path, notice: 'Company was successfully created.'
        else
          puts "error"
        end
      else
        render :new
      end
    else
      render :new
    end

  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to new_charge_path
  end

  # PATCH/PUT /companies/1
  def update
    old_tier = @company.tier
    puts old_tier
    if @company.update(company_params)
      if old_tier != @company.tier
        tier = @company.tier
        plan = ""
        if tier == "Small"
          plan = "001"
        elsif tier == "Basic"
          plan = "002"
        elsif tier == "Premium"
          plan = "003"
        elsif tier == "Enterprise"
          plan = "004"
        end
        subscription = Stripe::Subscription.retrieve(@company.subscription_id)
        subscription.plan = plan
        subscription.save
      end
      redirect_to edit_company_path(@company), notice: 'Company was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /companies/1
  def destroy
    @company.destroy
    redirect_to root_path, notice: 'Company was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_company
      @company = current_user.company
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def company_params
      params.fetch(:company, {}).permit(:name, :email_subject_line, :email_title, :email_body, :tier)
    end

  	def detect_no_company
      if current_user != nil && current_user.company_id == nil
        redirect_to "/users/edit"
      elsif current_user != nil && current_user.company_id != nil
        @current_company = current_user.company
      end
  	end
end
