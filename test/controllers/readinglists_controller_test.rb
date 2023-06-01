require "test_helper"

class ReadinglistsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @readinglist = readinglists(:one)
  end

  test "should get index" do
    get readinglists_url
    assert_response :success
  end

  test "should get new" do
    get new_readinglist_url
    assert_response :success
  end

  test "should create readinglist" do
    assert_difference("Readinglist.count") do
      post readinglists_url, params: { readinglist: { date: @readinglist.date, isbn: @readinglist.isbn, register_date: @readinglist.register_date, shape: @readinglist.shape, status: @readinglist.status, title: @readinglist.title } }
    end

    assert_redirected_to readinglist_url(Readinglist.last)
  end

  test "should show readinglist" do
    get readinglist_url(@readinglist)
    assert_response :success
  end

  test "should get edit" do
    get edit_readinglist_url(@readinglist)
    assert_response :success
  end

  test "should update readinglist" do
    patch readinglist_url(@readinglist), params: { readinglist: { date: @readinglist.date, isbn: @readinglist.isbn, register_date: @readinglist.register_date, shape: @readinglist.shape, status: @readinglist.status, title: @readinglist.title } }
    assert_redirected_to readinglist_url(@readinglist)
  end

  test "should destroy readinglist" do
    assert_difference("Readinglist.count", -1) do
      delete readinglist_url(@readinglist)
    end

    assert_redirected_to readinglists_url
  end
end
