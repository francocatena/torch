class ApplicationController < ActionController::Base
  helper_method :current_user_session, :current_user
  
  protect_from_forgery
  
  # Rescue any exception and show it in a "nice" page
  rescue_from Exception do |exception|
    begin
      @title = t 'errors.title'
      error = "#{exception.class}: #{exception.message}\n\n"
      exception.backtrace.each { |l| error << "#{l}\n" }

      logger.error(error)

      unless response.redirect_url
        render 'shared/show_error', locals: { error: exception }
      end

    # En caso que la presentación misma de la excepción no salga como se espera
    rescue => ex
      error = "#{ex.class}: #{ex.message}\n\n"
      ex.backtrace.each { |l| error << "#{l}\n" }

      logger.error(error)
    end
  end
  
  private
  
  def current_user_session
    @current_user_session ||= UserSession.find
  end

  def current_user
    @current_user ||= current_user_session && current_user_session.record
  end
  
  def user_for_paper_trail
    current_user.try :id
  end
  
  def require_user
    unless current_user
      flash.notice = t('messages.must_be_logged_in')

      store_location
      redirect_to admin_url

      false
    else
      expires_now
    end
  end

  def require_no_user
    if current_user
      flash.notice = t('messages.must_be_logged_out')

      store_location
      redirect_to apps_url

      false
    else
      true
    end
  end
  
  def store_location
    session[:return_to] = request.fullpath
  end
  
  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)

    session[:return_to] = nil
  end
end