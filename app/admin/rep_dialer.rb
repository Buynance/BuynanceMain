ActiveAdmin.register RepDialer do

  menu :label => "Cold Caller"

  scope :awaiting_questionnaire
  scope :awaiting_acceptance
  scope :accepted
  scope :rejected

  member_action :accept_index, :method => :put do
      rep = RepDialer.find(params[:id])
      rep.accept
      flash[:notice] = "Representative Accepted"
      redirect_to :action => :index
  end

  member_action :reject_index, :method => :put do
      rep = RepDialer.find(params[:id])
      rep.reject
      flash[:notice] = "Representative Rejected"
      redirect_to :action => :index
  end

  index do
    column("Signup Time", :sortable => :created_at) {|rep| rep.created_at.strftime("%m/%d/%Y %I:%M%p")}
    #column("Name", :sortable => :id)                {|rep| link_to "#{rep.name}", grubraise_rep_dialer_path(rep)}
    column("Name", :sortable => :id)                {|rep| link_to "#{rep.name}", "#{rep.profile_url}"}
    column("Email")                                 {|rep| rep.email}
    column("Paypal Email")                          {|rep| rep.paypal_email}
    column("State")                                 {|rep| status_tag rep.state}
    column("Referal Code")                          {|rep| rep.referral_code}
    actions
    actions defaults: false do |rep|
      if rep.state == "awaiting_acceptance"
        link_to "Accept", accept_index_grubraise_rep_dialer_path(rep), method: :put, class: "member_link"
        #link_to "Reject", reject_index_grubraise_rep_dialer_path(rep), method: :put, class: "member_link"
      end
    end
    actions defaults: false do |rep|
      if rep.state == "awaiting_acceptance"
        #link_to "Accept", accept_index_grubraise_rep_dialer_path(rep), method: :put, class: "member_link"
        link_to "Reject", reject_index_grubraise_rep_dialer_path(rep), method: :put, class: "member_link"
      end
    end
  end

  controller do
    def permitted_params
      params.permit rep_dialer: [:name, :email, :paypal_email, :referral_code]
    end
  end

  form do |f|
    f.inputs "Details" do
      f.input :name
      f.input :email
      f.input :paypal_email
      f.input :referral_code
    end
    f.actions
  end

  show do |rep_dialer|
  
    columns do
      column do
        panel 'Basic Information' do
          attributes_table_for rep_dialer do
            row :id
            row("Signup Time")    {|rep_dialer| rep_dialer.created_at.strftime("%m/%d/%Y %I:%M%p")}
            row("Name")           {|rep_dialer| link_to "#{rep_dialer.name}", "#{rep_dialer.profile_url}"}
            row("Email")          {|rep_dialer| rep_dialer.email}
            row("Paypal Email")   {|rep_dialer| rep_dialer.paypal_email}
            row("State")          {|rep_dialer| status_tag rep_dialer.state}
            row("Referal Code")   {|rep_dialer| rep_dialer.referral_code}
            row("Mobile Number")  {|rep_dialer| rep_dialer.mobile_number}
          end
        end
      end     
    end

    columns do
      column do
        panel "Questionnaire" do
          table_for Answer.where(rep_dialer_id: rep_dialer.id).each do |answer|
            column("Question") {|answer| Question.find_by(id: answer.question_id).question_text}
            column("Answer")   {|answer| answer.answer_text}
          end 
        end
      end
    end

    columns do
      column do
        panel "Leads Proccessed" do
          table_for ReferralPayment.where(rep_dialer_id: rep_dialer.id).each do |rep_transaction|
           
          end 
        end
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
