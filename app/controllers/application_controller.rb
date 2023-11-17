class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods

  before_action :authenticate

  rescue_from JSON::Schema::ValidationError, with: :render_json_schema_validation_error

  private

  def authenticate
    if Rails.configuration.x.access_token.present?
      valid = authenticate_with_http_token do |token, _options|
        ActiveSupport::SecurityUtils.secure_compare(token, Rails.configuration.x.access_token)
      end

      if !valid
        render json: {error: "Unauthorized"}, status: :unauthorized
      end
    end
  end

  def render_json_schema_validation_error(e)
    render json: {error: e.message}, status: :bad_request
  end
end
