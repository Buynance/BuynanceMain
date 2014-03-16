class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery 
  before_filter :make_action_mailer_use_request_host_and_protocol
  helper_method :current_business_session, :current_business, 
    :require_business, :x_months_ago_string, :zero?, :return_error_class
  force_ssl if: :ssl_configured?

  private
  	def after_sign_out_path_for(resource_or_scope)
    	root_path
  	end

  	def after_sign_in_path_for(resource_or_scope)
    	root_path
  	end
  	
    def configure_permitted_parameters
  		devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:email, :password, :password_confirmation) }
	  end


    def current_business_session
      return @current_business_session if defined?(@current_business_session)
      @current_business_session = BusinessSession.find
    end

    def current_business
      return @current_business if defined?(@current_business)
      @current_business = current_business_session && current_business_session.business
    end

    def require_business
      logger.debug "ApplicationController::require_business"
      unless current_business
        store_location
        flash[:notice] = "You must be logged in to access this page"
        redirect_to new_business_session_url
        return false
      end
    end

    def require_no_business
      logger.debug "ApplicationController::require_no_business"
      if current_business
        store_location
        if (current_business.is_finished_application)
          flash[:notice] = "You can not login twice, please logout if you want to login"
          redirect_to account_url
        else
          redirect_to business_steps_path
        end
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


end
