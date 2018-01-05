require 'test_helper'

class WebContentsControllerTest < ActionController::TestCase
  setup do
    @web_content = web_contents(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:web_contents)
  end

  test "should create web_content" do
    assert_difference('WebContent.count') do
      post :create, web_content: { url: "https://facebook.com", content: "faces faces everywhere"  }
    end

    assert_redirected_to api_web_content_path(assigns(:web_content))
  end
end
