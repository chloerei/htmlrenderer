class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods

  before_action :authenticate

  private

  def authenticate
    if Rails.configuration.x.auth_token.present?
      valid = authenticate_with_http_token do |token, _options|
        ActiveSupport::SecurityUtils.secure_compare(token, Rails.configuration.x.auth_token)
      end

      if !valid
        render json: { error: "Unauthorized" }, status: :unauthorized
      end
    end
  end
end
