ActiveAdmin.register ReferralPayment do

  scope :awaiting_payment
  scope :paid

  member_action :pay_index, :method => :put do
      referral_payment = ReferralPayment.find(params[:id])
      referral_payment.pay
      flash[:notice] = "Representative Paid"
      redirect_to :action => :index
  end

  index do 
    column("Business")            do |referral_payment|
      business = Business.find_by_id(referral_payment.business_id)
      unless business.nil? 
        link_to "#{business.name}", grubraise_business_path(business)
      else
        "Deleted"
      end
    end
    column("Representative")      do |referral_payment| 
      rep_dialer = RepDialer.find_by_id(referral_payment.rep_dialer_id)
      unless rep_dialer.nil?
        rep_dialer.name
      else
        "Deleted"
      end
    end
    column("Referral Code")      do |referral_payment| 
      rep_dialer = RepDialer.find_by_id(referral_payment.rep_dialer_id)
      unless rep_dialer.nil?
        rep_dialer.referral_code
      else
        "Deleted"
      end
    end

    column("Amount") {|referral_payment| ActionController::Base.helpers.number_to_currency referral_payment.amount }
    column("Status") {|referral_payment| status_tag(referral_payment.state) }     
    
    actions do |referral_payment|
      if referral_payment.state == "awaiting_payment"
        link_to "Pay", pay_index_grubraise_referral_payment_path(referral_payment), method: :put, class: "member_link"
      end
    end
  end


  controller do
    def permitted_params
      params.permit referral_payment: [:amount]
    end
  end

  form do |f|
    f.inputs "Details" do
      f.input :amount
    end
    f.actions
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
