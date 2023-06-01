require "test_helper"

class AbcsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @abc = abcs(:one)
  end

  test "should get index" do
    get abcs_url
    assert_response :success
  end

  test "should get new" do
    get new_abc_url
    assert_response :success
  end

  test "should create abc" do
    assert_difference("Abc.count") do
      post abcs_url, params: { abc: { s: @abc.s, zid: @abc.zid } }
    end

    assert_redirected_to abc_url(Abc.last)
  end

  test "should show abc" do
    get abc_url(@abc)
    assert_response :success
  end

  test "should get edit" do
    get edit_abc_url(@abc)
    assert_response :success
  end

  test "should update abc" do
    patch abc_url(@abc), params: { abc: { s: @abc.s, zid: @abc.zid } }
    assert_redirected_to abc_url(@abc)
  end

  test "should destroy abc" do
    assert_difference("Abc.count", -1) do
      delete abc_url(@abc)
    end

    assert_redirected_to abcs_url
  end
end
