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
      user = User.find_by_email(params[:user][:email])
      session[:user_id] = user.id
      Log.new({user: user.user, subject: "user:"+user.user, operation: "Logged in" }).save
    else
      redirect_to root_path
    end
    super
  end

  # DELETE /resource/sign_out
  def destroy
    Log.new({user: current_user.user, 
              subject: "user:"+current_user.user,
              operation: "Logged out" }).save
    super
    current_user = nil
  end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_in_params
    devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  end
end
