require 'test_helper'

class ForbiddensControllerTest < ActionDispatch::IntegrationTest
  setup do
    @forbidden = forbiddens(:one)
  end

  test "should get index" do
    get forbiddens_url
    assert_response :success
  end

  test "should get new" do
    get new_forbidden_url
    assert_response :success
  end

  test "should create forbidden" do
    assert_difference('Forbidden.count') do
      post forbiddens_url, params: { forbidden: { user: @forbidden.user, relation: @forbidden.relation } }
    end

    assert_redirected_to forbidden_url(Forbidden.last)
  end

  test "should show forbidden" do
    get forbidden_url(@forbidden)
    assert_response :success
  end

  test "should get edit" do
    get edit_forbidden_url(@forbidden)
    assert_response :success
  end

  test "should update forbidden" do
    patch forbidden_url(@forbidden), params: { forbidden: { user: @forbidden.user, relation: @forbidden.relation } }
    assert_redirected_to forbidden_url(@forbidden)
  end

  test "should destroy forbidden" do
    assert_difference('Forbidden.count', -1) do
      delete forbidden_url(@forbidden)
    end

    assert_redirected_to forbiddens_url
  end
end
