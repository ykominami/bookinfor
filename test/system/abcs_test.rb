require "application_system_test_case"

class AbcsTest < ApplicationSystemTestCase
  setup do
    @abc = abcs(:one)
  end

  test "visiting the index" do
    visit abcs_url
    assert_selector "h1", text: "Abcs"
  end

  test "should create abc" do
    visit abcs_url
    click_on "New abc"

    fill_in "S", with: @abc.s
    fill_in "Zid", with: @abc.zid
    click_on "Create Abc"

    assert_text "Abc was successfully created"
    click_on "Back"
  end

  test "should update Abc" do
    visit abc_url(@abc)
    click_on "Edit this abc", match: :first

    fill_in "S", with: @abc.s
    fill_in "Zid", with: @abc.zid
    click_on "Update Abc"

    assert_text "Abc was successfully updated"
    click_on "Back"
  end

  test "should destroy Abc" do
    visit abc_url(@abc)
    click_on "Destroy this abc", match: :first

    assert_text "Abc was successfully destroyed"
  end
end
