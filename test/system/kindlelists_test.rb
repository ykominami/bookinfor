require "application_system_test_case"

class KindlelistsTest < ApplicationSystemTestCase
  setup do
    @kindlelist = kindlelists(:one)
  end

  test "visiting the index" do
    visit kindlelists_url
    assert_selector "h1", text: "Kindlelists"
  end

  test "should create kindlelist" do
    visit kindlelists_url
    click_on "New kindlelist"

    fill_in "Asin", with: @kindlelist.asin
    fill_in "Author", with: @kindlelist.author
    fill_in "Publish date", with: @kindlelist.publish_date
    fill_in "Publisher", with: @kindlelist.publisher
    fill_in "Purchase date", with: @kindlelist.purchase_date
    fill_in "Title", with: @kindlelist.title
    click_on "Create Kindlelist"

    assert_text "Kindlelist was successfully created"
    click_on "Back"
  end

  test "should update Kindlelist" do
    visit kindlelist_url(@kindlelist)
    click_on "Edit this kindlelist", match: :first

    fill_in "Asin", with: @kindlelist.asin
    fill_in "Author", with: @kindlelist.author
    fill_in "Publish date", with: @kindlelist.publish_date
    fill_in "Publisher", with: @kindlelist.publisher
    fill_in "Purchase date", with: @kindlelist.purchase_date
    fill_in "Title", with: @kindlelist.title
    click_on "Update Kindlelist"

    assert_text "Kindlelist was successfully updated"
    click_on "Back"
  end

  test "should destroy Kindlelist" do
    visit kindlelist_url(@kindlelist)
    click_on "Destroy this kindlelist", match: :first

    assert_text "Kindlelist was successfully destroyed"
  end
end
