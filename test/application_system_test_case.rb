require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_chrome, screen_size: [1400, 900]

  # Transactional tests wrap data in a rolled-back transaction, but the Puma
  # server thread uses a separate DB connection and can't see uncommitted data.
  # With this off, data is committed, so Devise can authenticate test users.
  self.use_transactional_tests = false

  setup do
    # Capybara.reset_sessions! navigates to about:blank before deleting cookies,
    # so localhost session cookies survive. Visiting a public page first puts the
    # browser on the correct domain so delete_all_cookies actually works.
    visit new_user_session_path
    page.driver.browser.manage.delete_all_cookies
  end

  teardown do
    # Delete in FK-safe order: children before parents.
    Message.delete_all
    Chat.delete_all
    Pairing.delete_all
    Request.delete_all
    UserProfile.delete_all
    User.delete_all
    # ActionCable broadcasts are persisted in solid_cable_messages. Without
    # cleanup, a stale broadcast could be replayed into the next test's browser
    # via the Solid Cable polling mechanism.
    ActiveRecord::Base.connection.execute("DELETE FROM solid_cable_messages")
  end

  def sign_in_as(user)
    # Direct server-side sign-in avoids depending on Turbo's handling of
    # the Devise form redirect, which can fail to persist the session cookie
    # when running tests sequentially in the same browser instance.
    visit test_sign_in_path(user)
  end
end
