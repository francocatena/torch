class ApplicationController < ActionController::Base
  protect_from_forgery
  
  # Rescue any exception and show it in a "nice" page
  rescue_from Exception do |exception|
    begin
      @title = t :'errors.title'
      error = "#{exception.class}: #{exception.message}\n\n"
      exception.backtrace.each { |l| error << "#{l}\n" }

      logger.error(error)

      unless response.redirect_url
        render 'shared/show_error', error: exception
      end

    # En caso que la presentaci贸n misma de la excepci贸n no salga como se espera
    rescue => ex
      error = "#{ex.class}: #{ex.message}\n\n"
      ex.backtrace.each { |l| error << "#{l}\n" }

      logger.error(error)
    end
  end
end