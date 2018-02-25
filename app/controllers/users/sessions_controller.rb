class Users::SessionsController < Devise::SessionsController
# before_action :configure_sign_in_params, only: [:create]
# protect_from_forgery prepend: true
# prepend_before_filter :require_no_authentication, only: [:cancel ]
  # GET /resource/sign_in
  def new
    super
  end

  # POST /resource/sign_in
  def create
    if User.find_by_email(params[:user][:email]).present?
      session[:user_id] = User.find_by_email(params[:user][:email]).id
    else
      redirect_to root_path
    end
  end

  # DELETE /resource/sign_out
  def destroy
    super
  end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_in_params
    devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  end
end
