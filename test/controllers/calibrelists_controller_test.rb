require "test_helper"

class CalibrelistsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @calibrelist = calibrelists(:one)
  end

  test "should get index" do
    get calibrelists_url
    assert_response :success
  end

  test "should get new" do
    get new_calibrelist_url
    assert_response :success
  end

  test "should create calibrelist" do
    assert_difference("Calibrelist.count") do
      post calibrelists_url, params: { calibrelist: { author_sort: @calibrelist.author_sort, authors: @calibrelist.authors, comments: @calibrelist.comments, formats: @calibrelist.formats, isbn: @calibrelist.isbn, languages: @calibrelist.languages, library_name: @calibrelist.library_name, pubdate: @calibrelist.pubdate, publisher: @calibrelist.publisher, series: @calibrelist.series, series_index: @calibrelist.series_index, size: @calibrelist.size, tags: @calibrelist.tags, timestamp: @calibrelist.timestamp, title: @calibrelist.title, title_sort: @calibrelist.title_sort, uuid: @calibrelist.uuid, xid: @calibrelist.xid, xxid: @calibrelist.xxid, zid: @calibrelist.zid } }
    end

    assert_redirected_to calibrelist_url(Calibrelist.last)
  end

  test "should show calibrelist" do
    get calibrelist_url(@calibrelist)
    assert_response :success
  end

  test "should get edit" do
    get edit_calibrelist_url(@calibrelist)
    assert_response :success
  end

  test "should update calibrelist" do
    patch calibrelist_url(@calibrelist), params: { calibrelist: { author_sort: @calibrelist.author_sort, authors: @calibrelist.authors, comments: @calibrelist.comments, formats: @calibrelist.formats, isbn: @calibrelist.isbn, languages: @calibrelist.languages, library_name: @calibrelist.library_name, pubdate: @calibrelist.pubdate, publisher: @calibrelist.publisher, series: @calibrelist.series, series_index: @calibrelist.series_index, size: @calibrelist.size, tags: @calibrelist.tags, timestamp: @calibrelist.timestamp, title: @calibrelist.title, title_sort: @calibrelist.title_sort, uuid: @calibrelist.uuid, xid: @calibrelist.xid, xxid: @calibrelist.xxid, zid: @calibrelist.zid } }
    assert_redirected_to calibrelist_url(@calibrelist)
  end

  test "should destroy calibrelist" do
    assert_difference("Calibrelist.count", -1) do
      delete calibrelist_url(@calibrelist)
    end

    assert_redirected_to calibrelists_url
  end
end
