require 'cgi'

ActiveAdmin.register Business do

  actions :index, :show, :destroy

  scope :personal
  scope :financial
  scope :revise
  scope :bank_prelogin
  scope :bank_login
  scope :bank_login_error
  scope :email_confirmation
  scope :mobile_confirmation
  scope :accepted_market
  scope :accepted_buynance_fast_advance
  scope :accepted_buynance_fast_advance_plus
  scope :accepted_affiliate_advance


  filter :name
  filter :email
  filter :created_at
  filter :owner_first_name
  filter :owner_last_name
  filter :city
  filter :location_state, label: "STATE"
  filter :zip_code
  filter :phone_number
  filter :mobile_number
  filter :funding_type
  filter :is_tax_lien
  filter :is_payment_plan
  filter :is_ever_bankruptcy
  filter :is_refinance


  

  action_item :only => :show do
    link_to 'Download XLS (Funder)', "#{export_grubraise_business_path(business)}.xls"
  end
  
  action_item :only => :show do
    link_to 'Download CSV', "/grubraise/businesses.csv?email_equals%5D=#{CGI::escape(business.email)}&commit=Filter&order=id_desc"
  end

  action_item :only => :show do
    link_to 'Download CSV Anonymous', "/grubraise/businesses.csv?email_equals%5D=#{CGI::escape(business.email)}&commit=Filter&order=id_desc&anon=true"
  end

  action_item :only => :show do
    if business.bank_account
      link_to 'Download CSV Transactions', "/grubraise/transactions.csv?bank_account_id_eq%5D=#{business.bank_account.id}&commit=Filter&order=id_desc"
    end
  end


  action_item :only => :index do
    link_to 'Download Anonymous CSV', "/grubraise/businesses.csv?anon=true&commit=Filter&order=id_desc"
  end

  action_item :only => :index do
    link_to 'Download CSV', "/grubraise/businesses.csv?commit=Filter&order=id_desc"
  end

  action_item :only => :show do

  end

  index do 
    column("Signup Time", :sortable => :created_at) {|business| business.created_at.strftime("%m/%d/%Y %I:%M%p")}
    column("Business", :sortable => :id)            {|business| link_to "#{business.name}", grubraise_business_path(business)}
    column("Email")                                 {|business| business.email}
    column("Funnel")                                {|business| status_tag(business.is_refinance ? "Revise" : "Funder")}
    column("Current Step")                          {|business| status_tag(business.step) }
    column("Owner's Name")                          {|business| "#{business.owner_first_name} #{business.owner_last_name}"}
    column("State")                                 {|business| business.location_state}
    column("Business Phone")                        {|business| business.phone_number}
    column("Mobile Phone")                          {|business| business.mobile_number}
    column("Referral Code")                       do |business|
      unless business.rep_dialer_id.nil?
        rep_dialer = RepDialer.find_by(id: business.rep_dialer_id)
        unless rep_dialer.nil?
          rep_dialer.referral_code
        else
          "Deleted"
        end
      end
    end
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
            row("Funnel")                     {|business| status_tag(business.is_refinance ? "Revise" : "Funder")}
            row("Current Step")               {|business| status_tag(business.step) }
            row("Referral Code")            do |business|
              unless business.rep_dialer_id.nil?
                rep_dialer = RepDialer.find_by(id: business.rep_dialer_id)
                unless rep_dialer.nil?
                  rep_dialer.referral_code
                else
                  "Deleted"
                end
              end
            end
          end
        end

        panel 'Personal Information' do
          attributes_table_for business do
            row("Email")                      {|business| business.email}
            row("Name")                       {|business| business.name}
            row("Owners First Name")          {|business| business.owner_first_name}
            row("Owners Last Name")           {|business| business.owner_last_name}
            row("Phone Number")               {|business| GlobalPhone.parse(business.phone_number).national_format unless business.phone_number.nil?}
            row("Mobile Number")              {|business| GlobalPhone.parse(business.mobile_number).national_format unless business.mobile_number.nil?}
            row("Street Adress Line One")     {|business| business.street_address_one}
            row("Street Adress Line Two")     {|business| business.street_address_two}
            row("City")                       {|business| business.city}
            row("State")                      {|business| business.location_state}
            row("Zip Code")                   {|business| business.zip_code}
            row("New Phone Number")           {|business| GlobalPhone.parse(business.routing_number.phone_number).national_format unless business.routing_number.nil?}
            row("Years in Business")          {|business| business.years_in_business}
          end
        end  
      end
    
      column do
        panel 'Financial & Bank Information' do
          attributes_table_for business do
            row("Bank Account State")       {|business| status_tag(business.bank_account.state) if !business.bank_account.nil?}
            row("Bank Name")                {|business| (business.bank_account.institution_name) unless business.bank_account.nil? }
            row("Account Number")           {|business| (business.bank_account.account_number) unless business.bank_account.nil? }
            row("Routing Number")           {|business| (business.bank_account.routing_number) unless business.bank_account.nil? }
            row("Oldest Transaction Date")  {|business| (business.bank_account.transactions_from_date) unless business.bank_account.nil? }
            row("Newest Transaction Date")  {|business| (business.bank_account.transactions_to_date) unless business.bank_account.nil? }
            row("Days of Transaction")      {|business| (business.bank_account.days_of_transactions) unless business.bank_account.nil? }
            row("Available Balance")        {|business| (number_to_currency business.bank_account.current_balance) unless business.bank_account.nil? }
            row("Average Balance")          {|business| (number_to_currency business.bank_account.average_balance) unless business.bank_account.nil? }
            row("Total Number of Deposits") {|business| (business.bank_account.total_number_of_deposits) unless business.bank_account.nil? }
            row("Total Deposits Value")     {|business| (number_to_currency business.bank_account.total_deposits_value) unless business.bank_account.nil?} 
            row("Total Negative Days")      {|business| (business.bank_account.total_negative_days) unless business.bank_account.nil? }
            row("Deposit One Months Ago")   {|business| number_to_currency business.bank_account.deposits_one_month_ago unless business.bank_account.nil?}
            row("Deposit Two Months Ago")   {|business| number_to_currency business.bank_account.deposits_two_months_ago unless business.bank_account.nil?}
            row("Deposit Three Months Ago") {|business| number_to_currency business.bank_account.deposits_three_months_ago unless business.bank_account.nil?}
            row("Average Monthly Deposits") {|business| ActionController::Base.helpers.number_to_currency business.bank_account.average_monthly_deposit unless (business.bank_account.nil? or business.bank_account.average_monthly_deposit.nil?)}
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
            row("Current IP")   {|business| business.business_user.current_login_ip unless business.business_user.nil?}
            row("Signup City")  {|business| business.signup_city}
            row("Signup Country") {|business| business.signup_country}
            row("Signup Postal Code") {|business| business.signup_postal}
            row :activation_code
          end
        end
      end     
    end

    columns do
      column do
        panel "Transactions" do

          span "Transactions Type : ", style: "padding-right: 1.5%; font-weight: bold;"
          span "Payroll"
          span " (py)", style: "padding-right: 3%;"
          span "Loan Debit"
          span " (ld)", style: "padding-right: 3%;"
          span "Loan Credit"
          span " (lc)", style: "padding-right: 3%;"
          span "Overdraft"
          span " (ov)", style: "padding-right: 3%;"
          span "ACH Debit"
          span " (ad)", style: "padding-right: 3%;"
          span "ACH Credit"
          span " (ac)", style: "padding-right: 3%;"
          span "Deposits"
          span " (dp)", style: "padding-right: 3%;"
          span "Reversals"
          span " (rv)", style: "padding-right: 3%;"

          table_for business.bank_account.transactions.each do |transaction|
            column("Date", :sortable => :transaction_date) {|transaction| transaction.transaction_date.strftime("%m/%d/%Y")}
            column("Amount", :sortable => :amount)         {|transaction| ActionController::Base.helpers.number_to_currency transaction.amount}
            column("Type")                                 {|transaction| transaction.type_code}
            column(:description)                           {|transaction| transaction.description}
            column(:running_balance)                       {|transaction| ActionController::Base.helpers.number_to_currency transaction.running_balance}
          end unless business.bank_account.nil?
        end
      end
    end

    columns do
      column do
        panel "Offers" do
          table_for business.offers.each do |offer|
            column("Type")              {|offer| offer.name}
            column("Amount Recieved")   {|offer| ActionController::Base.helpers.number_to_currency offer.cash_advance_amount}
            column("Amount Payed")      {|offer| ActionController::Base.helpers.number_to_currency offer.total_payback_amount}
            column(:state)                           {|offer| status_tag offer.state}
          end unless business.bank_account.nil?
        end
      end
    end
    
  end

  member_action :export do
    @business = Business.find(params[:id])
    respond_to do |format|
      format.html
      format.xls do
        stream = render_to_string(:template=>"grubraise/businesses/export" )  
        send_data(stream, filename: "ID_#{@business.id+406723}.xls")
      end
      format.csv do
        send_data business.to_csv, filename: "#{@business.created_at.strftime('%Y%m%d-%H%M%S')}_#{@business.id}_business.csv"
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

  csv do
    unless params[:anon] == "true"
      column("Business User ID")           {|business| business.business_user.id}
      column("Business Name")              {|business| business.name}
    end
    column("Business Type")              {|business| business.business_type.name unless business.business_type.nil?} 
    unless params[:anon] == "true"
      column("Funnel")                     {|business| business.is_refinance ? "Revise" : "Funder"}
      column("Current Step")               {|business| business.step }
      column("Email")                      {|business| business.email}
      column("Name")                       {|business| business.name}
      column("Owners First Name")          {|business| business.owner_first_name}
      column("Owners Last Name")           {|business| business.owner_last_name}
      column("Phone Number")               {|business| GlobalPhone.parse(business.phone_number).national_format unless business.routing_number.nil?}
      column("Mobile Number")              {|business| GlobalPhone.parse(business.mobile_number).national_format unless business.routing_number.nil?}
      column("Street Adress Line One")     {|business| business.street_address_one}
      column("Street Adress Line Two")     {|business| business.street_address_two}
      column("City")                       {|business| business.city}
      column("State")                      {|business| business.location_state}
    end
    column("Zip Code")                   {|business| business.zip_code}
    column("Credit Score")               {|business| business.credit_score_range}
    unless params[:anon] == "true"
      column("Bank Account State")         {|business| business.bank_account.state if !business.bank_account.nil?}
      column("Account Number")             {|business| (business.bank_account.account_number) unless business.bank_account.nil? }
      column("Routing Number")             {|business| (business.bank_account.routing_number) unless business.bank_account.nil? }
    end
    column("Bank Name")                  {|business| (business.bank_account.institution_name) unless business.bank_account.nil? }
    column("Oldest Transaction Date")    {|business| (business.bank_account.transactions_from_date) unless business.bank_account.nil? }
    column("Newest Transaction Date")    {|business| (business.bank_account.transactions_to_date) unless business.bank_account.nil? }
    column("Days of Transaction")        {|business| (business.bank_account.days_of_transactions) unless business.bank_account.nil? }
    column("Available Balance")          {|business| (ActionController::Base.helpers.number_to_currency business.bank_account.current_balance) unless business.bank_account.nil? }
    column("Average Balance")            {|business| (ActionController::Base.helpers.number_to_currency business.bank_account.average_balance) unless business.bank_account.nil? }
    column("Total Number of Deposits")   {|business| (business.bank_account.total_number_of_deposits) unless business.bank_account.nil? }
    column("Total Deposits Value")       {|business| (ActionController::Base.helpers.number_to_currency business.bank_account.total_deposits_value) unless business.bank_account.nil?} 
    column("Total Negative Days")        {|business| (business.bank_account.total_negative_days) unless business.bank_account.nil? }
    column("Deposit One Months Ago")     {|business| ActionController::Base.helpers.number_to_currency business.bank_account.deposits_one_month_ago unless business.bank_account.nil?}
    column("Deposit Two Months Ago")     {|business| ActionController::Base.helpers.number_to_currency business.bank_account.deposits_two_months_ago unless business.bank_account.nil?}
    column("Deposit Three Months Ago")   {|business| ActionController::Base.helpers.number_to_currency business.bank_account.deposits_three_months_ago unless business.bank_account.nil?}
    column("Average Monthly Deposits")   {|business| ActionController::Base.helpers.number_to_currency business.bank_account.average_monthly_deposit unless (business.bank_account.nil? or business.bank_account.average_monthly_deposit.nil?)}
    column("Tax Lien?")                  {|business| (business.is_tax_lien ?  "yes" : "no" )}
    column("Payment Plan?")              {|business| (business.is_payment_plan ? "yes" : "no" )}
    column("Bankruptcy?")                {|business| (business.is_ever_bankruptcy ? "yes" :  "no" )}

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
