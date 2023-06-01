require "test_helper"

class KindlelistsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @kindlelist = kindlelists(:one)
  end

  test "should get index" do
    get kindlelists_url
    assert_response :success
  end

  test "should get new" do
    get new_kindlelist_url
    assert_response :success
  end

  test "should create kindlelist" do
    assert_difference("Kindlelist.count") do
      post kindlelists_url, params: { kindlelist: { asin: @kindlelist.asin, author: @kindlelist.author, publish_date: @kindlelist.publish_date, publisher: @kindlelist.publisher, purchase_date: @kindlelist.purchase_date, title: @kindlelist.title } }
    end

    assert_redirected_to kindlelist_url(Kindlelist.last)
  end

  test "should show kindlelist" do
    get kindlelist_url(@kindlelist)
    assert_response :success
  end

  test "should get edit" do
    get edit_kindlelist_url(@kindlelist)
    assert_response :success
  end

  test "should update kindlelist" do
    patch kindlelist_url(@kindlelist), params: { kindlelist: { asin: @kindlelist.asin, author: @kindlelist.author, publish_date: @kindlelist.publish_date, publisher: @kindlelist.publisher, purchase_date: @kindlelist.purchase_date, title: @kindlelist.title } }
    assert_redirected_to kindlelist_url(@kindlelist)
  end

  test "should destroy kindlelist" do
    assert_difference("Kindlelist.count", -1) do
      delete kindlelist_url(@kindlelist)
    end

    assert_redirected_to kindlelists_url
  end
end
