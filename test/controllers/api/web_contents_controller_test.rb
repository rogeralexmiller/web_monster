require 'test_helper'
class Api::WebContentsControllerTest < ActionController::TestCase
  include Rails.application.routes.url_helpers

  setup do
    @web_content = web_contents(:one)
  end

  test "should get index" do
    expected = WebContent.all.pluck(:url, :content).map do |row|
      { row[0] => row[1] }
    end

    get "index", "api/web_contents", format: :json
    assert_response :success
    assert_not_nil assigns(:web_contents)
    assert_equal expected.to_json, response.body
  end

  test "should create web_content from a url" do
    assert_difference('WebContent.count', 1) do
      form = { url: "https://www.facebook.com" }
      post "create", "api/web_contents", form, format: 'json'
    end
  end

  test "should be able to create web_content from same urls of different structure" do
    assert_difference('WebContent.count', 1) do
      form = { url: "https://facebook.com" }
      post "create", "api/web_contents", form, format: 'json'
    end
  end

  test "should return 400 with message when non-existent website is passed" do
    form = { url: "https://www.fakewebsite3838429sljdlkfjlsflskdla.com" }
    post "create", "api/web_contents", form, format: 'json'
    assert_response 400
    body = JSON.parse(response.body)

    assert body['message'] == "Connection refused. Try a different url."
  end

  test "should return 400 with missing page when website throws 404" do
    form = { url: "https://www.google.com/hopefullyfakepage2828282" }
    post "create", "api/web_contents", form, format: 'json'
    assert_response 400
    body = JSON.parse(response.body)

    assert body['message'] == "Missing page responded 404: No content found at that url."
  end

  test "should return 400 with different message when malformed url is passed" do
    form = { url: "hcci://definitely_fake.com" }
    post "create", "api/web_contents", form, format: 'json'
    assert_response 400
    body = JSON.parse(response.body)
    assert body['message'] == "Bad protocol. Url must start with valid protocol like 'https://'"
  end

  with_routing do |set|
    set.draw { set.connect ':controller/:id/:action' }
    assert_equal(
       ['/content/10/show', {}],
       set.generate(:controller => 'content', :id => 10, :action => 'show')
    )
  end
end
