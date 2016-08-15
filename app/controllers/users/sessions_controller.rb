class Users::SessionsController < Devise::SessionsController
  def after_sign_out_path_for(resource_or_scope)
    '/users/sign_in'
  end
end
