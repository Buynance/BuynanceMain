class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery 
  before_filter :make_action_mailer_use_request_host_and_protocol
  helper_method :current_business_user_session, :current_business_user, 
    :require_business_user, :x_months_ago_string, :zero?, :return_error_class,
     :current_business
  force_ssl if: :ssl_configured?

  private
    def after_sign_out_path_for(resource_or_scope)
      root_path
    end

    def after_sign_in_path_for(resource_or_scope)
      root_path
    end

    def current_business_user_session
      return @current_business_user_session if defined?(@current_business_user_session)
      @current_business_user_session = BusinessUserSession.find
    end

    def current_business_user
      return @current_business_user if defined?(@current_business_user)
      @current_business_user = current_business_user_session && current_business_user_session.business_user
    end

    def current_business
      if current_business_user
        return Business.find(current_business_user.business_id, no_obfuscated_id: true)
      else
        return false
      end
    end

    def require_business_user
      logger.debug "ApplicationController::require_business_user"
      unless current_business_user
        store_location
        flash[:notice] = "You must be logged in to access this page"
        redirect_to new_business_user_session_url
        return false
      end
    end

    def require_no_business_user
      logger.debug "ApplicationController::require_no_business_user"
      if current_business_user
        store_location
        flash[:notice] = "You can not login twice, please logout if you want to login"
        redirect_to business_url(current_business)
        return false
      end
    end

    def store_location
      #session[:return_to] = request.request_uri
    end

    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end

    def x_months_ago(x)
      Date.today.prev_month(x).month 
    
    end

    def x_months_ago_string(x)
      month_to_string(x_months_ago(x))
    end

    def month_to_string(x)
      Date::MONTHNAMES[x]
    end

    def zero?(num)
      return (num == 0)
    end

    def make_action_mailer_use_request_host_and_protocol
      ActionMailer::Base.default_url_options[:protocol] = request.protocol
      ActionMailer::Base.default_url_options[:host] = request.host_with_port
    end

    def ssl_configured?
      !Rails.env.development?
    end

    def return_error_class(model, attribute)
      return 'has-error' if model.errors.include?(attribute)
      return ''
    end

    def send_activation_text
      number_to_send_to = "+13473567903"
 
      twilio_sid = "ACa599ee1205fbc22bab49c5c12586b143"
      twilio_token = "d4944731dadc8bb487486d99169240c9"
      twilio_phone_number = "9146104411"
 
      @twilio_client = Twilio::REST::Client.new twilio_sid, twilio_token
 
      @twilio_client.account.sms.messages.create(
        :from => "+1#{twilio_phone_number}",
        :to => number_to_send_to,
        :body => "A new account has signed up"
      )
    end

    def grab_business_and_business_user
      @business_user = current_business_user
      @business = current_business
    end
end
