ActiveAdmin.register Funder do

  
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

  index do
    column :id
    column :name
    column :email
    column :paypal_email
    column :sign_in_count
    column :current_sign_in_at
    column :last_sign_in_at
    column :current_sign_in_ip
    column :last_sign_in_ip
    column :created_at
    column :updated_at
  end

  show do |funder|
      attributes_table do
        row :id
        row :name
        row :email
        row :paypal_email
        row :sign_in_count
        row :current_sign_in_at
        row :last_sign_in_at
        row :current_sign_in_ip
        row :last_sign_in_ip
        row :created_at
        row :updated_at
      end
      active_admin_comments
    end

  form do |f|
    f.inputs "Funders" do
        f.input :name
        f.input :email
        if f.object.new_record?
          f.input :password
          f.input :password_confirmation
        end
        f.input :paypal_email
        f.actions
    end
  end

  controller do
    def permitted_params
      params.permit funder: [:email, :password, :password_confirmation, :name, :paypal_email]
    end
  end
end
