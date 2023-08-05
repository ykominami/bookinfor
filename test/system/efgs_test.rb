require "application_system_test_case"

class EfgsTest < ApplicationSystemTestCase
  setup do
    @efg = efgs(:one)
  end

  test "visiting the index" do
    visit efgs_url
    assert_selector "h1", text: "Efgs"
  end

  test "should create efg" do
    visit efgs_url
    click_on "New efg"

    fill_in "S", with: @efg.s
    fill_in "Zid", with: @efg.zid
    click_on "Create Efg"

    assert_text "Efg was successfully created"
    click_on "Back"
  end

  test "should update Efg" do
    visit efg_url(@efg)
    click_on "Edit this efg", match: :first

    fill_in "S", with: @efg.s
    fill_in "Zid", with: @efg.zid
    click_on "Update Efg"

    assert_text "Efg was successfully updated"
    click_on "Back"
  end

  test "should destroy Efg" do
    visit efg_url(@efg)
    click_on "Destroy this efg", match: :first

    assert_text "Efg was successfully destroyed"
  end
end
