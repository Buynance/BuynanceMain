ActiveAdmin.register Business do

  actions :index, :show, :destroy

  scope :all, :default => true
  scope :awaiting_persona_information
  scope :awaiting_email_confirmation
  scope :awaiting_mobile_confirmation


  index do 
    column("Business", :sortable => :id) {|business| "##{business.id} "}
    column("Business State")             {|business| business.state}
    column("Business Name")              {|business| business.name}
    #column("State")                      {|business| status_tag(business.state) }
    column("Email")                      {|business| link_to business.business_user.email, grubraise_business_user_path(BusinessUser.find_by(email: business.email))}
    column("Owner's First Name")         {|business| business.owner_first_name}
    column("Owner's Last Name")          {|business| business.owner_last_name}
    #column("Address Line One")           {|business| business.street_address_one}
    #column("City")                       {|business| business.city}
    column("State")                      {|business| business.location_state}
    #column("Zip Code")                   {|business| business.zip_code}
    column("Business Phone")             {|business| business.phone_number}
    column("Mobile Phone")               {|business| business.mobile_number}
    #column("")
    
    actions
  end

  show do |business|
    columns do
      column do
        panel 'Basic Information' do
          attributes_table_for business do
            row :id
            row("Business User ID")           {|business| link_to business.business_user.id, grubraise_business_user_path(business.business_user)}
            row("Business Name")              {|business| business.name}
            row("Business Type")              {|business| business.business_type.name unless business.business_type.nil?} 
            row("State")                      {|business| status_tag(business.state) }
            #row("Average Monthly Deposits")   {|business| number_to_currency (business.earned_one_month_ago + business.earned_two_months_ago + business.earned_three_months_ago)/3}
            #row("Average Daily Balance")      {|business| number_to_currency business.average_daily_balance_bank_account}
          end
        end

        panel 'Personal Information' do
          attributes_table_for business do
            row("Email")                      {|business| business.email}
            row("Name") {|business| business.name}
            row("Owners First Name") {|business| business.first_name}
            row("Owners Last Name") {|business| business.last_name}
            row("Phone Number") {|business| business.phone_number}
            row("Mobile Number") {|business| business.mobile_number}
            row("Street Adress Line One") {|business| business.street_address_one}
            row("Street Adress Line Two") {|business| business.street_address_two}
            row("City") {|business| business.city}
            row("State") {|business| business.location_state}
            row("Zip Code") {|business| business.zip_code}

          end
        end  
      end
    
      column do
        panel 'Financial & Bank Information' do
          attributes_table_for business do
            row("Bank Account State")      {|business| status_tag(business.bank_account.state) if !business.bank_account.nil?}
            row("Bank Name")               {|business| (business.bank_account.institution_name) unless business.bank_account.nil? }
            row("Account Number")          {|business| (business.bank_account.account_number) unless business.bank_account.nil? }
            row("Routing Number")          {|business| (business.bank_account.routing_number) unless business.bank_account.nil? }
            row("Oldest Transaction Date") {|business| (business.bank_account.transactions_from_date) unless business.bank_account.nil? }
            row("Newest Transaction Date") {|business| (business.bank_account.transactions_to_date) unless business.bank_account.nil? }
            row("Days of Transaction")     {|business| (business.bank_account.days_of_transactions) unless business.bank_account.nil? }
            row("Available Balance")       {|business| (number_to_currency business.bank_account.available_balance) unless business.bank_account.nil? }
            row("Average Balance")         {|business| (number_to_currency business.bank_account.average_balance) unless business.bank_account.nil? }
            row("Total Number of Deposits") {|business| (business.bank_account.total_number_of_deposits) unless business.bank_account.nil? }
            row("Total Deposits Value")     {|business| (number_to_currency business.bank_account.total_deposits_value) unless business.bank_account.nil?} 
            row("Total Negative Days")      {|business| (business.bank_account.total_negative_days) unless business.bank_account.nil? }
            row("Earned One Months Ago") {|business| number_to_currency business.earned_one_month_ago}
            row("Earned Two Months Ago") {|business| number_to_currency business.earned_two_months_ago}
            row("Earned Three Months Ago") {|business| number_to_currency business.earned_three_months_ago}
            #row("Average Monthly Deposits")   {|business| number_to_currency (business.earned_one_month_ago + business.earned_two_months_ago + business.earned_three_months_ago)/3}
            #row("Average Daily Balance")      {|business| number_to_currency business.average_daily_balance_bank_account}
            #row("Negative Days Last Month")   {|business| business.amount_negative_balance_past_month}
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
            row("Tax Lien?") {|business| (business.is_tax_lien ? status_tag( "yes", :ok ) : status_tag( "no" ))}
            row("Payment Plan?") {|business| (business.is_payment_plan ? status_tag( "yes", :ok ) : status_tag( "no" ))}
            row("Bankruptcy?") {|business| (business.is_ever_bankruptcy ? status_tag( "yes", :ok ) : status_tag( "no" ))}
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
