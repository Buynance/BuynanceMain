ActiveAdmin.register BusinessUser do

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
  menu false

  show do  |business_user|
    panel 'Basic Information' do
      attributes_table_for business_user do
        row("Id") {|business_user| business_user.id}
        row("Business") {|business_user| link_to business_user.business_id, grubraise_business_path(Business.find(business_user.business_id, no_obfuscated_id: true))}
        row  :email
        row("Encrypted Password") {|business_user| business_user.crypted_password}
        row   :reset_password_token
        row :reset_password_sent_at
        row :remember_created_at
        row  :login_count 
        row :current_login_at
        row :last_login_at
        row   :current_login_ip
        row   :last_login_ip
        row   :persistence_token
        row   :single_access_token
        row   :perishable_token
        row  :failed_login_count
        row :last_request_at
        row :created_at
        row :updated_at
      end
    end
  end

  index do
    column("ID") {|business_user| business_user.id}
    column("Email") {|business_user| business_user.email}
    #column("Encrypted Password") {|business_user| business_user.crypted_password}
    column("Created At") {|business_user| business_user.created_at}
    column("Updated At") {|business_user| business_user.updated_at}
    column("Failed Login Count") {|business_user| business_user.failed_login_count}
    actions
  end
  
end
