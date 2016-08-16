class Users::RegistrationsController < Devise::RegistrationsController
  before_filter :configure_permitted_parameters

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
    devise_parameter_sanitizer.for(:sign_up).push(:email, :firstname, :lastname, :password, :password_confirmation)
    devise_parameter_sanitizer.for(:account_update).push(:email, :firstname, :lastname, :password, :password_confirmation, :company_code)
  end

  def detect_no_company
    if current_user != nil && current_user.company_id == nil
      redirect_to "/users/edit"
    end
  end
end
