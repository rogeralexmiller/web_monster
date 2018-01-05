require 'test_helper'

class WebContentTest < ActiveSupport::TestCase
  setup do
    @null_url = WebContent.new(url: nil)
    @bad_url = WebContent.new(url: "htt://ww.badsite.com")
    @good_url = web_contents(:one)
  end

  test "should not save without a url" do
    assert_not @null_url.save
  end

  test "should not save a malformed url" do
    assert_not @bad_url.save
  end

  test "should save a good url" do
    assert @good_url.save
  end
end
