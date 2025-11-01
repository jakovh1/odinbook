class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :render_error_toast
  rescue_from ActiveRecord::RecordInvalid, with: :render_error_toast

  before_action :authenticate_user!
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  def render_error_toast(exception = nil)
    flash.now[:alert] = "An error occurred, please try again."
    render turbo_stream: turbo_stream.replace("toast", partial: "layouts/toast"), status: :not_found

    case exception
    when ActiveRecord::RecordInvalid
      Rails.logger.warn("Validation failed: #{exception.record.errors.full_messages.join(', ')}")
    when ActiveRecord::RecordNotFound
      Rails.logger.warn("Record not found: #{exception.message}")
    when nil
      Rails.logger.warn("An error occurred.")
    else
      Rails.logger.error("Unexpected error: #{exception.class} - #{exception.message}")
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :username ])
    devise_parameter_sanitizer.permit(:account_update, keys: [ :username ])
  end
end
