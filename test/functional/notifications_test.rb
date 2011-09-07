require 'test_helper'

class NotificationsTest < ActionMailer::TestCase
  test 'new comment' do
    comment = Comment.find(comments(:is_ok).id)
    mail = Notifications.new_comment(comment)
    assert_equal I18n.t('notifications.new_comment.subject'), mail.subject
    assert_equal [comment.user.email], mail.to
    assert_equal [APP_CONFIG['smtp']['user_name']], mail.from
    assert_match 'Tiene un nuevo comentario', mail.body.encoded
    
    assert_difference 'ActionMailer::Base.deliveries.size' do
      mail.deliver
    end
  end
end