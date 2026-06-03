require "application_system_test_case"

class PairingsTest < ApplicationSystemTestCase
  setup do
    @user1   = User.create!(email: "user1@example.com", password: "password12345")
    @user2   = User.create!(email: "user2@example.com", password: "password12345")
    @pairing = Pairing.create!(user_id_1: @user1.id, user_id_2: @user2.id)
    @chat    = @pairing.chat

    @chat.messages.create!(role: "user",      content: "What exercises for chest?",                          user: @user1)
    @chat.messages.create!(role: "assistant", content: "Try bench press and push-ups for a solid chest workout!")
  end

  test "shows both users and existing messages including the assistant reply" do
    sign_in_as @user1
    visit pairing_path(@pairing)

    assert_text @user1.email
    assert_text @user2.email
    assert_text "What exercises for chest?"
    assert_text "Try bench press and push-ups for a solid chest workout!"
  end

  test "user2 can access the same pairing and sees the full conversation" do
    sign_in_as @user2
    visit pairing_path(@pairing)

    assert_text @user1.email
    assert_text @user2.email
    assert_text "What exercises for chest?"
    assert_text "Try bench press and push-ups for a solid chest workout!"
    assert_selector "form#new_message"
  end

  test "submitting a message disables the form while waiting for the AI response" do
    sign_in_as @user1
    visit pairing_path(@pairing)

    fill_in "Message", with: "Can you suggest a full workout plan?"
    click_button "Send message"

    # Stimulus disables the fields immediately on submit; the turbo stream
    # response then replaces the form with HTML-disabled fields.
    assert_selector "textarea[disabled]"
    assert_selector "input[type='submit'][disabled]"
  end
end
