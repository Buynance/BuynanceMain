class RepDialer < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  before_create :setup_referral_code

  state_machine :state, :initial => :awaiting_paypal do

    event :add_paypal do
      transition [:awaiting_paypal] => :awaiting_acceptance 
    end

    event :accept do
      transition [:awaiting_acceptance] => :accepted
    end

  end

  def self.connect_to_linkedin(auth, signed_in_resource=nil)
    rep_dialer = RepDialer.where(:provider => auth.provider, :uid => auth.uid).first
    if rep_dialer
      return rep_dialer
    else
      registered_rep_dialer = RepDialer.where(:email => auth.info.email).first
      if registered_rep_dialer
        return registered_rep_dialer
      else
        rep_dialer = RepDialer.create(name:auth.info.first_name,
          provider:auth.provider,
          uid:auth.uid,
          email:auth.info.email,
          password:Devise.friendly_token[0,20]
        )
      end
    end
  end  

  private

  def setup_referral_code
    code = SecureRandom.hex(3)
    while RepDialer.find_by(referral_code: code).nil? == false
      code = SecureRandom.hex(3)
    end
    self.referral_code = code
  end 

end
