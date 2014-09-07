module BusinessNotifications
  extend ActiveSupport::Concern

  included do

    # Bulk Notifications

    def send_qulaified_lead_notifications!
      if Rails.env.production?
        self.deliver_qualified_user_sms!
        self.deliver_qualified_user!
      end
    end

    def send_bank_prelogin_notification!
      if self.bank_prelogin? and Rails.env.production?
        self.deliver_bank_login_interuption!
      end
    end
    handle_asynchronously :send_bank_prelogin_notification!, :run_at => Proc.new { 5.minutes.from_now }, :priority => 5

    def send_bank_login_notification!
      if self.bank_login? and Rails.env.production?
        self.deliver_bank_login_interuption!
      end
    end
    handle_asynchronously :send_bank_login_notification!, :run_at => Proc.new { 5.minutes.from_now }, :priority => 5



    # Email Notifications

    def deliver_qualified_user!
      BusinessMailer.qualified_user(self).deliver! if Rails.env.production?
    end
    handle_asynchronously :deliver_qualified_user!, :priority => 5

    def deliver_jared_email!
      BusinessMailer.jared_success_signup(self).deliver!
    end

    #SMS Notifications

    def deliver_qualified_user_sms!
      TwilioLib.send_text("7169085466", "We have a new qualified user. Name: #{self.owner_first_name} #{self.owner_last_name}. Funnel: #{(self.is_refinance ? "Revise" : "Funder")}")
      TwilioLib.send_text("7169087957", "We have a new qualified user. Name: #{self.owner_first_name} #{self.owner_last_name}. Funnel: #{(self.is_refinance ? "Revise" : "Funder")}")
    end
    handle_asynchronously :deliver_qualified_user_sms!, :priority => 5

    def deliver_bank_login_interuption!
      BusinessMailer.bank_interuption(self).deliver!
      TwilioLib.send_text("7169085466", "Warning! A user has dropped from bank login. Name: #{self.owner_first_name} #{self.owner_last_name}. Phone number is #{self.mobile_number}. Funnel: #{(self.is_refinance ? "Revise" : "Funder")}")
      TwilioLib.send_text("3473567903", "Warning! A user has dropped from bank login. Name: #{self.owner_first_name} #{self.owner_last_name}. Phone number is #{self.mobile_number}. Funnel: #{(self.is_refinance ? "Revise" : "Funder")}")
      TwilioLib.send_text("7169087957", "Warning! A user has dropped from bank login. Name: #{self.owner_first_name} #{self.owner_last_name}. Phone number is #{self.mobile_number}. Funnel: #{(self.is_refinance ? "Revise" : "Funder")}")
    end
 
  end
end  