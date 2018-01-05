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

  test "should return 400 with message when non-existent url is passed" do
    form = { url: "https://www.fakewebsite3838429sljdlkfjlsflskdla" }
    post "create", "api/web_contents", form, format: 'json'
    assert_response 400
    body = JSON.parse(response.body)
    assert body['message'] == "Couldn't fetch or parse web page."
  end

  test "should return 400 with different message when malformed url is passed" do
    form = { url: "hcci://definitely_fake.com" }
    post "create", "api/web_contents", form, format: 'json'
    assert_response 400
    body = JSON.parse(response.body)
    assert body['message'] == "Bad protocol. Url must start with valid protocol like 'https://'"
  end
end
