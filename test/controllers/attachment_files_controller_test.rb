require 'test_helper'

class AttachmentFilesControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get attachment_files_create_url
    assert_response :success
  end

  test "should get destroy" do
    get attachment_files_destroy_url
    assert_response :success
  end

end
