require "application_system_test_case"

class ReadinglistsTest < ApplicationSystemTestCase
  setup do
    @readinglist = readinglists(:one)
  end

  test "visiting the index" do
    visit readinglists_url
    assert_selector "h1", text: "Readinglists"
  end

  test "should create readinglist" do
    visit readinglists_url
    click_on "New readinglist"

    fill_in "Date", with: @readinglist.date
    fill_in "Isbn", with: @readinglist.isbn
    fill_in "Register date", with: @readinglist.register_date
    fill_in "Shape", with: @readinglist.shape
    fill_in "Status", with: @readinglist.status
    fill_in "Title", with: @readinglist.title
    click_on "Create Readinglist"

    assert_text "Readinglist was successfully created"
    click_on "Back"
  end

  test "should update Readinglist" do
    visit readinglist_url(@readinglist)
    click_on "Edit this readinglist", match: :first

    fill_in "Date", with: @readinglist.date
    fill_in "Isbn", with: @readinglist.isbn
    fill_in "Register date", with: @readinglist.register_date
    fill_in "Shape", with: @readinglist.shape
    fill_in "Status", with: @readinglist.status
    fill_in "Title", with: @readinglist.title
    click_on "Update Readinglist"

    assert_text "Readinglist was successfully updated"
    click_on "Back"
  end

  test "should destroy Readinglist" do
    visit readinglist_url(@readinglist)
    click_on "Destroy this readinglist", match: :first

    assert_text "Readinglist was successfully destroyed"
  end
end
