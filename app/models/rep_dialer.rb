class RepDialer < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  attr_accessor :agree_confirmation, :current_step

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  has_one :questionnaire_completed, :dependent => :destroy
  has_many :referral_payments

  before_create :setup_referral_code
  before_create :set_defualts

  

  validates :paypal_email, 
  format: {with: /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/, message: "Please include a valid Paypal email."},
  allow_nil: true

  validate :parse_phone_number

  validate :agreement_check


  scope :awaiting_questionnaire,      where(state: "awaiting_questionnaire")
  scope :awaiting_acceptance,      where(state: "awaiting_acceptance")
  scope :accepted,      where(state: "accepted")
  scope :rejected,      where(state: "rejected")

  state_machine :state, :initial => :awaiting_creation do

    after_transition :on => :accept do |rep_dialer, t|
      rep_dialer.send_representative_acceptance!
    end

    after_transition :on => :complete_questionnaire do |rep_dialer, t|
      rep_dialer.send_representative_signup_to_admin!
    end

    event :created do
      transition [:awaiting_creation] => :awaiting_questionnaire
    end

    event :complete_questionnaire do
      transition [:awaiting_questionnaire] => :awaiting_acceptance
    end

    event :accept do
      transition [:awaiting_acceptance] => :accepted
    end

    event :reject do
      transition [:awaiting_acceptance] => :rejected
    end

  end

# Mailer Funtions 

  def send_representative_acceptance!
    RepDialerMailer.representative_acceptance(self).deliver!
  end
  # handle_asynchronously :send_representative_acceptance!

  def send_representative_signup_to_admin!
    AdminMailer.new_representative_signup(self).deliver!
  end
  # handle_asynchronously :representative_signup_to_admin!

#############################################

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
          password:Devise.friendly_token[0,20],
          paypal_email: auth.info.email
        )
        rep_dialer.created!
      end
    end
    return rep_dialer
  end  

  private

  def setup_referral_code
    code = "#{SecureRandom.random_number(99999)}".rjust(5, '0')
    while RepDialer.find_by(referral_code: code).nil? == false
      code = "#{SecureRandom.random_number(99999)}".rjust(5, '0')
    end
    self.referral_code = code
  end 

  def parse_phone_number
    if self.current_step == "questionnaire"
      puts '======================================== phone enter'
      mobile_number_object = GlobalPhone.parse(self.mobile_number)
      mobile_number_object = nil if (mobile_number_object != nil and mobile_number_object.territory.name != "US")
      if mobile_number_object.nil?
        puts '======================================== phone added'
        errors.add(:mobile_number, "Please enter a valid US phone number.")
      else
        self.mobile_number = mobile_number_object.international_string      
      end
    end
  end

  def agreement_check
    if self.current_step == "questionnaire"
      puts '======================================== agree enter'

      unless self.agree_confirmation.downcase == "i agree"
        puts '======================================== agree added'

        errors.add(:agree_confirmation, "Please type 'I AGREE' to acknowledge you agree with the terms below.")
      end
    end
  end

  def set_defualts
    self.total_earning ||= 0.0; 
  end

end
