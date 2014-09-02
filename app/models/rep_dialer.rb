class RepDialer < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  before_create :setup_referral_code

  validates :paypal_email, 
  format: {with: /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/, message: "Please include a valid Paypal email."},
  allow_nil: true

  scope :awaiting_paypal,      where(state: "awaiting_paypal")
  scope :awaiting_acceptance,      where(state: "awaiting_acceptance")
  scope :accepted,      where(state: "accepted")
  scope :rejected,      where(state: "rejected")

  state_machine :state, :initial => :awaiting_acceptance do

    after_transition :on => :accept do |rep_dialer, t|
      rep_dialer.send_representative_acceptance!
    end

    event :add_paypal do
      transition [:awaiting_paypal] => :awaiting_acceptance 
    end

    event :accept do
      transition [:awaiting_acceptance] => :accepted
    end

    event :reject do
      transition [:awaiting_acceptance] => :rejected
    end

  end

  def send_representative_acceptance!
    RepDialerMailer.representative_acceptance(self).deliver!
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
        rep_dialer = RepDialer.create(name: "#{auth.info.first_name} #{auth.info.last_name}",
          profile_url: auth.info.urls.public_profile,
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
    code = "#{SecureRandom.random_number(99999)}"
    while RepDialer.find_by(referral_code: code).nil? == false
      code = SecureRandom.random_number(99999)
    end
    self.referral_code = code
  end 

end
