require "test_helper"

class EfgsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @efg = efgs(:one)
  end

  test "should get index" do
    get efgs_url
    assert_response :success
  end

  test "should get new" do
    get new_efg_url
    assert_response :success
  end

  test "should create efg" do
    assert_difference("Efg.count") do
      post efgs_url, params: { efg: { s: @efg.s, zid: @efg.zid } }
    end

    assert_redirected_to efg_url(Efg.last)
  end

  test "should show efg" do
    get efg_url(@efg)
    assert_response :success
  end

  test "should get edit" do
    get edit_efg_url(@efg)
    assert_response :success
  end

  test "should update efg" do
    patch efg_url(@efg), params: { efg: { s: @efg.s, zid: @efg.zid } }
    assert_redirected_to efg_url(@efg)
  end

  test "should destroy efg" do
    assert_difference("Efg.count", -1) do
      delete efg_url(@efg)
    end

    assert_redirected_to efgs_url
  end
end
