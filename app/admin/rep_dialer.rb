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
