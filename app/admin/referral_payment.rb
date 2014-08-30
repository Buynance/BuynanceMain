ActiveAdmin.register ReferralPayment do

  scope :awaiting_payment
  scope :payed

  member_action :pay_index, :method => :put do
      referral_payment = ReferralPayment.find(params[:id])
      #representative = RepDialer.find(referral_payment.rep_dialer_id)
      referral_payment.pay
      redirect_to :action => :index, :notice => "Representative Paid"
  end

  index do 
    column("Business")            {|referral_payment| link_to "#{Business.find(referral_payment.business_id, no_obfuscated_id: true).name}", grubraise_business_path(Business.find(referral_payment.business_id, no_obfuscated_id: true))}
    column("Representative")      {|referral_payment| RepDialer.find(referral_payment.rep_dialer_id).name}
    column("Status")              {|referral_payment| status_tag(referral_payment.state) }     
    
    actions do |referral_payment|
      if referral_payment.state == "awaiting_payment"
        link_to "Pay", pay_index_grubraise_referral_payment_path(referral_payment), method: :put, class: "member_link"
      end
    end
  end




  
  # See permitted parameters documentation:
  # https://github.com/gregbell/active_admin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  #
  # or
  #
  # permit_params do
  #  permitted = [:permitted, :attributes]
  #  permitted << :other if resource.something?
  #  permitted
  # end
  
end
