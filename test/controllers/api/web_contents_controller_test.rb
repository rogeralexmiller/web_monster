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

  test "should create web_content from a url" do
    assert_difference('WebContent.count', 1) do
      form = { url: "https://www.facebook.com" }
      post "create", "api/web_contents", form, format: 'json'
    end
  end

  test "should return 400 when invalid or non-existent url is passed" do
    form = { url: "https://www.fakewebsite3838429sljdlkfjlsflskdla" }
    post "create", "api/web_contents", form, format: 'json'
    assert_response 400
  end
end
