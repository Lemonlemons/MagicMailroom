class Users::RegistrationsController < Devise::RegistrationsController
  before_filter :configure_permitted_parameters
  before_action :get_company

  def after_inactive_sign_up_path_for(resource)
    '/users/sign_in'
  end

  protected

  def update_resource(resource, params)
    if params[:company_code] != nil
      @company = Company.find_by(company_code: params[:company_code])
      if @company != nil
        resource.company_id = @company.id
      end
    end
    resource.update_without_password(params)
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :firstname, :lastname, :password, :password_confirmation])
    devise_parameter_sanitizer.permit(:account_update, keys: [:email, :firstname, :lastname, :password, :password_confirmation, :company_code])
  end

  def detect_no_company
    if current_user != nil && current_user.company_id == nil
      redirect_to "/users/edit"
    end
  end

  def get_company
    if current_user != nil && current_user.company_id != nil
      @current_company = current_user.company
    end
  end
end
