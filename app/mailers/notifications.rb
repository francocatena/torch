class Notifications < ActionMailer::Base
  layout 'notifications_mailer'
  default from: "\"#{I18n.t('app_name')}\" <#{APP_CONFIG['smtp']['user_name']}>",
    charset: 'UTF-8',
    date: proc { Time.now }
  
  def new_comment(comment)
    @comment = comment
    
    mail to: comment.emails
  end
end
