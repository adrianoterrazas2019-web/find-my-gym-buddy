require "application_system_test_case"

class RequestsTest < ApplicationSystemTestCase
  setup do
    @sender    = User.create!(email: "sender@example.com",    password: "password")
    @recipient = User.create!(email: "recipient@example.com", password: "password")
    @request   = Request.create!(sender: @sender, recipient: @recipient)
  end

  test "recipient can accept a pending request, which creates a pairing" do
    sign_in_as @recipient
    visit requests_path

    assert_text @sender.email
    click_button "Accept"

    assert_text "Request accepted."
    assert Pairing.exists?(user_id_1: @sender.id, user_id_2: @recipient.id)
  end

  test "recipient can reject a pending request without creating a pairing" do
    sign_in_as @recipient
    visit requests_path

    assert_text @sender.email
    click_button "Reject"

    assert_text "Request denied."
    assert_not Pairing.exists?
  end
end
