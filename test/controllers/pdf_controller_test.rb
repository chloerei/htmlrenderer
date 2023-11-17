require "test_helper"

class PdfControllerTest < ActionDispatch::IntegrationTest
  test "should generate pdf by html" do
    post pdf_url, params: {html: "<h1>Hello, world!</h1>"}, as: :json
    assert_response :success
  end

  test "should render json validate error" do
    post pdf_url, params: {html: "<h1>Hello, world!</h1>", options: {scale: "foo"}}, as: :json
    assert_response :bad_request
  end
end
