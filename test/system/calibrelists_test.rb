require "application_system_test_case"

class CalibrelistsTest < ApplicationSystemTestCase
  setup do
    @calibrelist = calibrelists(:one)
  end

  test "visiting the index" do
    visit calibrelists_url
    assert_selector "h1", text: "Calibrelists"
  end

  test "should create calibrelist" do
    visit calibrelists_url
    click_on "New calibrelist"

    fill_in "Author sort", with: @calibrelist.author_sort
    fill_in "Authors", with: @calibrelist.authors
    fill_in "Comments", with: @calibrelist.comments
    fill_in "Formats", with: @calibrelist.formats
    fill_in "Isbn", with: @calibrelist.isbn
    fill_in "Languages", with: @calibrelist.languages
    fill_in "Library name", with: @calibrelist.library_name
    fill_in "Pubdate", with: @calibrelist.pubdate
    fill_in "Publisher", with: @calibrelist.publisher
    fill_in "Series", with: @calibrelist.series
    fill_in "Series index", with: @calibrelist.series_index
    fill_in "Size", with: @calibrelist.size
    fill_in "Tags", with: @calibrelist.tags
    fill_in "Timestamp", with: @calibrelist.timestamp
    fill_in "Title", with: @calibrelist.title
    fill_in "Title sort", with: @calibrelist.title_sort
    fill_in "Uuid", with: @calibrelist.uuid
    fill_in "Xid", with: @calibrelist.xid
    fill_in "Xxid", with: @calibrelist.xxid
    fill_in "Zid", with: @calibrelist.zid
    click_on "Create Calibrelist"

    assert_text "Calibrelist was successfully created"
    click_on "Back"
  end

  test "should update Calibrelist" do
    visit calibrelist_url(@calibrelist)
    click_on "Edit this calibrelist", match: :first

    fill_in "Author sort", with: @calibrelist.author_sort
    fill_in "Authors", with: @calibrelist.authors
    fill_in "Comments", with: @calibrelist.comments
    fill_in "Formats", with: @calibrelist.formats
    fill_in "Isbn", with: @calibrelist.isbn
    fill_in "Languages", with: @calibrelist.languages
    fill_in "Library name", with: @calibrelist.library_name
    fill_in "Pubdate", with: @calibrelist.pubdate
    fill_in "Publisher", with: @calibrelist.publisher
    fill_in "Series", with: @calibrelist.series
    fill_in "Series index", with: @calibrelist.series_index
    fill_in "Size", with: @calibrelist.size
    fill_in "Tags", with: @calibrelist.tags
    fill_in "Timestamp", with: @calibrelist.timestamp
    fill_in "Title", with: @calibrelist.title
    fill_in "Title sort", with: @calibrelist.title_sort
    fill_in "Uuid", with: @calibrelist.uuid
    fill_in "Xid", with: @calibrelist.xid
    fill_in "Xxid", with: @calibrelist.xxid
    fill_in "Zid", with: @calibrelist.zid
    click_on "Update Calibrelist"

    assert_text "Calibrelist was successfully updated"
    click_on "Back"
  end

  test "should destroy Calibrelist" do
    visit calibrelist_url(@calibrelist)
    click_on "Destroy this calibrelist", match: :first

    assert_text "Calibrelist was successfully destroyed"
  end
end
