ActiveAdmin.register Business do

  actions :index, :show

  scope :all, :default => true
  scope :awaiting_information
  scope :awaiting_confirmation
  scope :awaiting_offer_acceptance
  scope :awaiting_offer_submission
  scope :declined

  index do 
    column("Business", :sortable => :id) {|business| "##{business.id} "}
    column("State")                      {|business| status_tag(business.state) }
    column("Email")                      {|business| link_to business.email, grubraise_business_user_path(BusinessUser.find_by(email: business.email))}
    column("Average Monthly Deposits")   {|business| number_to_currency (business.earned_one_month_ago + business.earned_two_months_ago + business.earned_three_months_ago)/3}
    column("Average Daily Balance")      {|business| number_to_currency business.average_daily_balance_bank_account}

    default_actions
  end

  show do |business|
    columns do
      column do
        panel 'Basic Information' do
          attributes_table_for business do
            row :id
            row("State")                      {|business| status_tag(business.state) }
            row("Email")                      {|business| business.email}
            row("Average Monthly Deposits")   {|business| number_to_currency (business.earned_one_month_ago + business.earned_two_months_ago + business.earned_three_months_ago)/3}
            row("Average Daily Balance")      {|business| number_to_currency business.average_daily_balance_bank_account}
          end
        end

        panel 'Personal Information' do
          attributes_table_for business do
            row("Email")                      {|business| business.email}
            row("Name") {|business| business.name}
            row("Owners First Name") {|business| business.owner_first_name}
            row("Owners Last Name") {|business| business.owner_last_name}
            row("Phone Number") {|business| business.phone_number}
            row("Mobile Number") {|business| business.mobile_number}
            row("Street Adress Line One") {|business| business.street_address_one}
            row("Street Adress Line Two") {|business| business.street_address_two}
            row("City") {|business| business.city}
            row("Zip Code") {|business| business.zip_code}
          end
        end  
      end
    
      column do
        panel 'Financial Information' do
          attributes_table_for business do
            row("Earned One Months Ago") {|business| number_to_currency business.earned_one_month_ago}
            row("Earned Two Months Ago") {|business| number_to_currency business.earned_two_months_ago}
            row("Earned Three Months Ago") {|business| number_to_currency business.earned_three_months_ago}
            row("Average Monthly Deposits")   {|business| number_to_currency (business.earned_one_month_ago + business.earned_two_months_ago + business.earned_three_months_ago)/3}
            row("Average Daily Balance")      {|business| number_to_currency business.average_daily_balance_bank_account}
            row("Negative Days Last Month")   {|business| business.amount_negative_balance_past_month}
            row("Credit Score") do |business|
              range = ""
              range = "400-500" if business.approximate_credit_score_range == 1
              range = "501-550" if business.approximate_credit_score_range == 2
              range = "551-600" if business.approximate_credit_score_range == 3
              range = "601-650" if business.approximate_credit_score_range == 4
              range = "651-700" if business.approximate_credit_score_range == 5
              range = "701-750" if business.approximate_credit_score_range == 6
              range = "751-800" if business.approximate_credit_score_range == 7
              range
            end
            row("Tax Lien?") {|business| business.is_tax_lien}
            row("Payment Plan?") {|business| business.is_payment_plan}
            row("Bankruptcy?") {|business| business.is_ever_bankruptcy}
          end
        end

      panel 'Misc' do
        attributes_table_for business do
          row :login_count
          row :current_login_at
          row :last_login_at
          row :current_login_ip
          row :last_login_ip
          row :created_at
          row :updated_at
          row :activation_code
        end
      end
    end     
  end

  panel 'Offers' do
        table_for business.offers do
          column("Offer", :sortable => :id)             {|offer| "##{offer.id} "}
          column("Active")                              {|offer| offer.is_active }
          column("Best Offer")                          {|offer| offer.is_best_offer }
          column("Date", :created_at)
          column("Customer", :sortable => :business_id) {|offer| BusinessUser.find(Business.find(offer.business_id, no_obfuscated_id: true).main_business_user_id, no_obfuscated_id: true).email if !Business.find(offer.business_id, no_obfuscated_id: true).nil?}
          column("Cash Advance Amount")                 {|offer| number_to_currency offer.cash_advance_amount}
          column("Daily Collection")                    {|offer| number_to_currency offer.daily_merchant_cash_advance}
          column("Payback Amount")                      {|offer| number_to_currency offer.total_payback_amount}
          column("Factor Rate")                         {|offer| offer.factor_rate}
        end
      end
      active_admin_comments
  end

  form do |f|
    f.inputs "Businesses" do
        f.input :name
        f.input :email
        if f.object.new_record?
          f.input :password
          f.input :password_confirmation
        end
        f.input :owner_first_name
        f.input :owner_last_name
        f.input :open_date
        f.input :is_authenticated
        f.input :is_accepting
        f.input :is_accept_credit_cards 
        f.actions
    end
  end

  controller do
    def permitted_params
      params.permit business: [:email, :password, :password_confirmation, :name, :owner_first_name, :owner_last_name, :open_date, :is_authenticated, :is_accept_credit_cards, :is_accepting]
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
