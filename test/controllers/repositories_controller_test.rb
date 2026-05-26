require "test_helper"

class RepositoriesControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get repositories_show_url
    assert_response :success
  end

  test "should get new" do
    get repositories_new_url
    assert_response :success
  end

  test "should get create" do
    get repositories_create_url
    assert_response :success
  end

  test "should get edit" do
    get repositories_edit_url
    assert_response :success
  end

  test "should get update" do
    get repositories_update_url
    assert_response :success
  end

  test "should get destroy" do
    get repositories_destroy_url
    assert_response :success
  end
end
