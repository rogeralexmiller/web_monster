require 'test_helper'
class Api::WebContentsControllerTest < ActionController::TestCase
  include Rails.application.routes.url_helpers

  setup do
    @web_content = web_contents(:one)
  end

  test "should get index" do
    get "index", "api/web_contents", format: :json
    assert_response :success
    assert_not_nil assigns(:web_contents)
  end

  test "should create web_content" do
    assert_difference('WebContent.count', 1) do
      form = { url: "https://www.facebook.com" }
      post "create", "api/web_contents", form, format: 'json'
    end
  end
end
