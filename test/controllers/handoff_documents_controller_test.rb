require "test_helper"

class HandoffDocumentsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get handoff_documents_show_url
    assert_response :success
  end

  test "should get new" do
    get handoff_documents_new_url
    assert_response :success
  end

  test "should get create" do
    get handoff_documents_create_url
    assert_response :success
  end

  test "should get edit" do
    get handoff_documents_edit_url
    assert_response :success
  end

  test "should get update" do
    get handoff_documents_update_url
    assert_response :success
  end
end
