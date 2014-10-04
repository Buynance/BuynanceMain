require 'mixpanel_lib'

class DialerApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  Authlogic::Session::Base.controller = Authlogic::ControllerAdapters::RailsAdapter.new(self)

  protect_from_forgery 
  before_filter :make_action_mailer_use_request_host_and_protocol
  helper_method :current_business_user_session, :current_business_user, 
    :require_business_user, :x_months_ago_string, :zero?, :return_error_class,
     :current_business, :current_funder, :require_funder, :to_boolean, :send_production_js, :is_production,
     :log_input_error

  private

  # Business and Business User
    def is_production
      #Rails.env.production?
      true
    end

    def send_production_js
      if current_business
        pluggable_js(is_production: is_production, email: current_business.business_user.email)
      else
        pluggable_js(is_production: is_production)
      end
    end

    def to_boolean(str)
      str == 'true'
    end

    def after_sign_out_path_for(resource_or_scope)
      if resource_or_scope == "rep_dialer".to_sym
        dialer_home_dialer_dashboards_path
      else 
        root_path
      end
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
        return Business.find(current_business_user.business_id)
      else
        return false
      end
    end

    def require_business_user
      logger.debug "ApplicationController::require_business_user"
      unless current_business_user
        store_location
        flash[:notice] = "You must be logged in to access this page"
        flash[:success_activation_message] = flash[:success_activation_message]
        flash[:faliure_activation_message] = flash[:faliure_activation_message]
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

    ####################################### Funder ########################################

    def current_funder_session
      return @current_funder_session if defined?(@current_funder_session)
      @current_funder_session = FunderSession.find
    end

    def current_funder
      return @current_funder if defined?(@current_funder)
      @current_funder = current_funder_session && current_funder_session.funder
    end

    def require_funder
      logger.debug "ApplicationController::require_funder"
      unless current_funder
        flash[:notice] = "You must be logged in to access this page"
        redirect_to new_funder_session_url
        return false
      end
    end

    def require_no_funder
      logger.debug "ApplicationController::require_no_funder"
      if current_funder
        store_location
        flash[:notice] = "You can not login twice, please logout if you want to login"
        redirect_to funder_url(current_funder)
        return false
      end
    end

    def require_rep_dialer
      unless current_rep_dialer
        redirect_to dialer_home_dialer_dashboards_path
      end
    end


    ######################################## Misc #########################################

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

    def ssl_configured?(ssl_required = true)
      !Rails.env.development? and ssl_required
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

    def send_activation_code

    end

    def grab_business_and_business_user
      @business_user = current_business_user
      @business = current_business
    end

    def log_input_error(object, page) 
      unless object.valid?
        object.errors.keys.each do |key|
          MixpanelLib.track(current_business.business_user.email, "Error - Input Field", {
            'Page' => page,
            'Field' => humanized_hash_keys(page)[key],
            'Message' => object.errors[key][0]
            })
        end
      end
    end
  
    def humanized_hash_keys(page)
      case page
      when "Signup Main"
        return {:email => "Email", :password => "Password", :password_confirmation => "Password Confirmation", :name => "Business Name", :is_refinance => "Funding Type"}
      when "Signup Personal"
        return {:years_in_business => "Years in Business", :owner_first_name => "Owner's First Name", :owner_last_name => "Owner's Last Name", 
          :street_address_one => "Street Address One", :street_address_two => "Street Address Two", :city => "City", :location_state => "State", :mobile_number => "Mobile Number", :zip_code => "Zip Code", :phone_number => "Phone Number", 
          :business_type_id => "Business Type", :mobile_disclaimer => "Mobile Disclaimer"}
      when "Signup Refinance"
        return {:deal_type => "Deal Type", :previous_merchant_id => "Current Funder", :previous_loan_date => "Current Loan Start Date", :total_previous_loan_amount => "Current MCA Given Amount",
            :total_previous_payback_amount => "Current MCA Payback Amount", :is_closing_fee => "Closing Fee", :closing_fee => "Closing Fee Amount", :total_previous_payback_balance => "Current MCA Balance"}
      when "Signup Financial"
        return {:approximate_credit_score_range => "Credit Score", :is_tax_lien => "Tax Lien", :is_payment_plan => "Tax Lien Payment Plan",
            :is_ever_bankruptcy => "Bankruptcy", :is_judgement => "Judgement"}
      when "Signup Bank Prelogin"
        return {:account_number => "Account Number", :routing_number => "Routing Number"}
      end
    end
end
