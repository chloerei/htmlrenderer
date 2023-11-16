require "test_helper"

class ImagesControllerTest < ActionDispatch::IntegrationTest
  test "should generate image by html" do
    post images_url, params: { html: "<h1>Hello, world!</h1>" }
    assert_response :success
  end
end
