require "test_helper"

class ScreenshotControllerTest < ActionDispatch::IntegrationTest
  test "should generate image by html" do
    post screenshot_url, params: {html: "<h1>Hello, world!</h1>"}, as: :json
    assert_response :success
  end

  test "should render json validate error" do
    post screenshot_url, params: {html: "<h1>Hello, world!</h1>", viewport: {width: "foo"}}, as: :json
    assert_response :bad_request
  end
end
