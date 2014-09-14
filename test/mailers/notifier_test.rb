require 'test_helper'

class NotifierTest < ActionMailer::TestCase
  test "timer_running" do
    mail = Notifier.timer_running
    assert_equal "Timer running", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
