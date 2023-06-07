require "test_helper"

class BooklistsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @booklist = booklists(:one)
  end

  test "should get index" do
    get booklists_url
    assert_response :success
  end

  test "should get new" do
    get new_booklist_url
    assert_response :success
  end

  test "should create booklist" do
    assert_difference("Booklist.count") do
      post booklists_url, params: { booklist: { asin: @booklist.asin, bookstore: @booklist.bookstore, category: @booklist.category, purchase_date: @booklist.purchase_date, read_status: @booklist.read_status, shape: @booklist.shape, title: @booklist.title, totalID: @booklist.totalID, xid: @booklist.xid } }
    end

    # assert_redirected_to booklist_url(Booklist.last)
  end

  test "should show booklist" do
    get booklist_url(@booklist)
    assert_response :success
  end

  test "should get edit" do
    get edit_booklist_url(@booklist)
    assert_response :success
  end

  test "should update booklist" do
    patch booklist_url(@booklist), params: { booklist: { asin: @booklist.asin, bookstore: @booklist.bookstore, category: @booklist.category, purchase_date: @booklist.purchase_date, read_status: @booklist.read_status, shape: @booklist.shape, title: @booklist.title, totalID: @booklist.totalID, xid: @booklist.xid } }
    # assert_redirected_to booklist_url(@booklist)
  end

  test "should destroy booklist" do
    assert_difference("Booklist.count", -1) do
      delete booklist_url(@booklist)
    end

    assert_redirected_to booklists_url
  end
end
