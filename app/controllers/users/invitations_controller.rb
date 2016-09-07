class Users::InvitationsController < Devise::InvitationsController
  before_action :get_company
  before_filter :configure_permitted_parameters

  protected

  # this is called when accepting invitation
  # should return an instance of resource class
  def accept_resource
    resource = resource_class.accept_invitation!(update_resource_params)
    @user = User.find(resource.invited_by_id)
    resource.company_id = @user.company.id
    resource.save
    resource
  end

  def get_company
    if current_user != nil && current_user.company_id != nil
      @current_company = current_user.company
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:accept_invitation, keys: [:email, :firstname, :lastname, :password, :password_confirmation, :invitation_token])
  end
end
