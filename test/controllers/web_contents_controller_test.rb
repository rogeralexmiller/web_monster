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

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create web_content" do
    assert_difference('WebContent.count') do
      post :create, web_content: {  }
    end

    assert_redirected_to web_content_path(assigns(:web_content))
  end

  test "should show web_content" do
    get :show, id: @web_content
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @web_content
    assert_response :success
  end

  test "should update web_content" do
    patch :update, id: @web_content, web_content: {  }
    assert_redirected_to web_content_path(assigns(:web_content))
  end

  test "should destroy web_content" do
    assert_difference('WebContent.count', -1) do
      delete :destroy, id: @web_content
    end

    assert_redirected_to web_contents_path
  end
end
