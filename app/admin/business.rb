ActiveAdmin.register Business do

  index do
    column :id
    column :name
    column :email
    column :owner_first_name
    column :owner_last_name
    column :open_date
    column :is_authenticated
    column :is_accepting
    column :is_accept_credit_cards
    column :login_count
    column :current_login_at
    column :last_login_at
    column :current_login_ip
    column :last_login_ip
    column :created_at
    column :updated_at
    column :phone_number
    column :is_email_confirmed 
    column :failed_login_count
    column :last_request_at
  end

  show do |business|
      attributes_table do
        row :id
        row :name
        row :email
        row :owner_first_name
        row :owner_last_name
        row :open_date
        row :is_authenticated
        row :is_accepting
        row :is_accept_credit_cards
        row :phone_number
        row :street_address_one
        row :street_address_two
        row :city
        row :state
        row :zip_code
        row :is_paying_back
        row :previous_merchant_id
        row :total_previous_payback_amount
        row :total_previous_payback_balance
        row :is_email_confirmed
        row :login_count
        row :current_login_at
        row :last_login_at
        row :current_login_ip
        row :last_login_ip
        row :created_at
        row :updated_at
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
