class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  before_action :authenticate_user!
  before_action :verify_user!, unless: :devise_controller?
  before_filter :configure_permitted_parameters, if: :devise_controller?

  protect_from_forgery with: :exception

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:account_update, keys: [:phone_number])
  end

  def verify_user!
    start_verification if requires_verification?
  end

  def start_verification
  result = Nexmo::Client.new.send_verification_request(
    number: current_user.phone_number,
    brand: "LucaTestJs",
    sender_id: 'RubyApp'
  )
  if result['status'] == '0'
      redirect_to edit_verification_path(id: result['request_id'])
    else
      sign_out current_user
      redirect_to :new_user_session, flash: {
        error: 'Could not verify your number. Please contact support.'
      }
    end
  end

  def requires_verification?
    session[:verified].nil? && !current_user.phone_number.blank?
  end
end
