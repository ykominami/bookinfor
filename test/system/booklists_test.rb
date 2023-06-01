require "application_system_test_case"

class BooklistsTest < ApplicationSystemTestCase
  setup do
    @booklist = booklists(:one)
  end

  test "visiting the index" do
    visit booklists_url
    assert_selector "h1", text: "Booklists"
  end

  test "should create booklist" do
    visit booklists_url
    click_on "New booklist"

    fill_in "Asin", with: @booklist.asin
    fill_in "Bookstore", with: @booklist.bookstore
    fill_in "Category", with: @booklist.category
    fill_in "Purchase date", with: @booklist.purchase_date
    fill_in "Read status", with: @booklist.read_status
    fill_in "Shape", with: @booklist.shape
    fill_in "Title", with: @booklist.title
    fill_in "Totalid", with: @booklist.totalID
    fill_in "Xid", with: @booklist.xid
    click_on "Create Booklist"

    assert_text "Booklist was successfully created"
    click_on "Back"
  end

  test "should update Booklist" do
    visit booklist_url(@booklist)
    click_on "Edit this booklist", match: :first

    fill_in "Asin", with: @booklist.asin
    fill_in "Bookstore", with: @booklist.bookstore
    fill_in "Category", with: @booklist.category
    fill_in "Purchase date", with: @booklist.purchase_date
    fill_in "Read status", with: @booklist.read_status
    fill_in "Shape", with: @booklist.shape
    fill_in "Title", with: @booklist.title
    fill_in "Totalid", with: @booklist.totalID
    fill_in "Xid", with: @booklist.xid
    click_on "Update Booklist"

    assert_text "Booklist was successfully updated"
    click_on "Back"
  end

  test "should destroy Booklist" do
    visit booklist_url(@booklist)
    click_on "Destroy this booklist", match: :first

    assert_text "Booklist was successfully destroyed"
  end
end
