module BusinessStates
  extend ActiveSupport::Concern

  included do

    scope :awaiting_persona_information,      where(state: "awaiting_personal_information")
    scope :awaiting_bank_information,         where(state: "awaiting_bank_information")
    scope :awaiting_email_confirmation,       where(state: "awaiting_email_confirmation")
    scope :awaiting_mobile_confirmation,      where(state: "awaiting_mobile_confirmation")
    scope :awaiting_offer_acceptance,         where(state: "awaiting_offer_acceptance")
    scope :awaiting_offer_completetion,       where(state: "awaiting_offer_completetion")
    scope :awaiting_reenter_market,           where(state: "awaiting_reenter_market")
    scope :awaiting_bank_information_refresh, where(state: "awaiting_bank_information_refresh")

    scope :personal,            where(step: "personal")
    scope :financial,           where(step: "financial")
    scope :revise,              where(step: "revise")
    scope :bank_prelogin,       where(step: "bank_prelogin")
    scope :bank_login,          where(step: "bank_login")
    scope :bank_login_error,    where(step: "bank_login_error")
    scope :email_confirmation,  where(step: "email_confirmation")
    scope :mobile_confirmation, where(step: "mobile_confirmation")
    scope :accepted_market,     where(step: "accepted_market")
    scope :accepted_buynance_fast_advance, where(step: "accepted_buynance_fast_advance")
    scope :accepted_buynance_fast_advance_plus, where(step: "accepted_buynance_fast_advance_plus")
    scope :accepted_affiliate_advance, where(step: "accepted_affiliate_advance")

    state_machine :step, :initial => :personal do

      after_transition :on => :passed_financial do |business, t|
        business.send_bank_prelogin_notification!
      end

      after_transition :on => :passed_bank_prelogin do |business, t|
        business.send_bank_login_notification!
      end

      after_transition :on => :passed_bank_login do |business, t|
        business.send_qualified_lead_notifications!
      end

      after_transition :on => :passed_mobile_confirmation do |business, t|
        #business.deliver_jared_email!
        ReferralPayment.add(business.id, business.rep_dialer_id) unless business.rep_dialer_id.nil?
      end

      after_transition :on => :passed_email_confirmation_referral do |business, t|
        unless business.rep_dialer_id.nil?
          ReferralPayment.add(business.id, business.rep_dialer_id) 
          business.deliver_business_representative_notification!
        end
      end

      after_transition :on => :accept_buynance_fast_advance do |business, t|

        business.send_offer_notification!
      end

      after_transition :on => :accept_buynance_fast_advance_plus do |business, t|
        business.send_offer_notification!
      end

      after_transition :on => :accept_affiliate_advance do |business, t|
        business.send_offer_notification!
      end

      event :passed_personal do
        transition [:personal] => :revise
      end

      event :passed_revise do
        transition [:revise] => :financial
      end

      event :passed_financial do
        transition [:financial] => :bank_prelogin
      end

      event :passed_bank_prelogin do
        transition [:bank_prelogin] => :bank_login
      end

      event :error_bank_prelogin do
        transition [:bank_prelogin] => :bank_login_error
      end

      event :passed_bank_login do
        transition [:bank_login] => :email_confirmation
      end

      event :passed_email_confirmation do
        transition [:email_confirmation] => :mobile_confirmation
      end

      event :passed_email_confirmation_referral do
        transition [:email_confirmation] => :accepted_market
      end

      event :passed_mobile_confirmation do
        transition [:mobile_confirmation] => :accepted_market
      end

      event :accept_buynance_fast_advance do
        transition [:accepted_market] => :accepted_buynance_fast_advance
      end

      event :accept_buynance_fast_advance_plus do
        transition [:accepted_market] => :accepted_buynance_fast_advance_plus
      end

      event :accept_affiliate_advance do
        transition [:accepted_market] => :accepted_affiliate_advance
      end

      event :reject_from_market do
        transition [:bank_login] => :reject_market
      end

      event :sell_from_market do
        transition [:accepted_market] => :sold_from_market
      end

    end

    state_machine :state, :initial => :awaiting_personal_information do
     
      event :personal_information_provided do
        transition [:awaiting_personal_information] => :awaiting_bank_information
      end
      # Business activate account is dependant on awaiting email confirmation
      event :bank_information_provided do
        transition [:awaiting_personal_information , :awaiting_bank_information] => :awaiting_email_confirmation
      end

      event :bank_error_occured do
        transition [:awaiting_personal_information , :awaiting_bank_information] => :bank_error
      end

      event :email_confirmation_provided do 
        transition [:awaiting_email_confirmation] => :awaiting_mobile_confirmation
      end

      event :email_confirmation_provided_referral do
        transition [:awaiting_email_confirmation] => :awaiting_offer_acceptance
      end


      event :mobile_confirmation_provided_phone do
        transition [:awaiting_mobile_confirmation] => :awaiting_offer_acceptance
      end

      event :mobile_confirmation_provided do
        transition [:awaiting_mobile_confirmation] => :awaiting_offer_acceptance
      end

      event :disclaimer_acceptance_provided do
        transition [:awaiting_disclaimer_acceptance] => :awaiting_offer_acceptance
      end

      event :offer_accepted do
        transition [:awaiting_offer_acceptance] => :awaiting_offer_completetion
      end
     
      event :offer_funded do
        transition [:awaiting_offer_completetion] => :awaiting_requalification
      end

      event :offer_rejected do
        transition [:awaiting_offer_completetion, :awaiting_offer_acceptance] => :awaiting_offer_acceptance
      end

      event :requalified do
        transition [:awaiting_requalification] => :awaiting_bank_information_refresh
      end

      event :bank_information_refreshed do
        transition [:awaiting_bank_information_refresh] => :awaiting_offer_acceptance
      end


    end

    state_machine :qualification_state, :initial => :awaiting_qualification_information do
      event :qualify_for_refi do
        transition [:awaiting_qualification_information] => :qualified_for_refi
      end

      event :disqualify_for_refi do
        transition [:awaiting_qualification_information] => :disqualified_for_refi
      end

      event :qualify_for_funder do
        transition [:awaiting_qualification_information] => :qualified_for_funder
      end

      event :qualify_for_market do
        transition [:awaiting_qualification_information] => :qualified_for_market
      end

      event :disqualify_for_refi do
        transition [:awaiting_qualification_information] => :disqualified_for_refi
      end
      
      event :disqualify do
        transition [:awaiting_qualification_information] => :disqualified_for_funder
      end

    end

  end
end  