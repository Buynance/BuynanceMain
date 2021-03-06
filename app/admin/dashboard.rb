require 'global_phone'

ActiveAdmin.register_page "Dashboard" do

  menu :priority => 1, :label => proc{ I18n.t("active_admin.dashboard") }

   content do
    columns do
      column do
        render partial: "active_admin/dashboard/new_user_ratio_google"
      end
      column do
        render partial: "active_admin/dashboard/signups_mixpanel"
      end
      column do
        render partial: "active_admin/dashboard/unique_vistors_week_google"
      end
      column do
        render partial: "active_admin/dashboard/bank_information_provided_today"
      end
    end
    columns do
      
      column do
        panel "Last 10 Businesses Signups" do
          table_for Business.order('id desc').limit(10).each do |business|
            column("Date", :sortable => :created_at) {|business| business.created_at.strftime("%m/%d/%Y %I:%M%p")}
            column("Business", :sortable => :id)     {|business| link_to "#{business.name}", grubraise_business_path(business)}
            column("Email")                          {|business| business.email}
            column("Funnel")                         {|business| status_tag(business.is_refinance ? "Revise" : "Funder")}
            column("Current Step")                   {|business| status_tag(business.step) }
            column("Owner's Name")                   {|business| "#{business.owner_first_name} #{business.owner_last_name}"}
            column("State")                          {|business| business.location_state}
            column("Business Phone")                 {|business| GlobalPhone.parse(business.phone_number).national_format unless business.phone_number.nil?}
            column("Mobile Phone")                   {|business| GlobalPhone.parse(business.mobile_number).national_format unless business.phone_number.nil?}
          end
        end
      end
    end
    columns do
      column do
        panel "Last 10 Leads" do
          table_for Lead.order('id desc').limit(10).each do |lead|
            column("Date", :sortable => :created_at) {|lead| lead.created_at.strftime("%m/%d/%Y %I:%M%p")}
            column("Business", :sortable => :id)     {|lead| link_to "#{lead.business.name}", grubraise_business_path(lead.business)}
            column("Email")                          {|lead| link_to lead.business.email, grubraise_business_user_path(BusinessUser.find_by(email: lead.business.email))}
            column("Funnel")                         {|lead| status_tag(lead.business.is_refinance ? "Revise" : "Funder")}
            column("Owner's Name")                   {|lead| "#{lead.business.owner_first_name} #{lead.business.owner_last_name}"}
            column("State")                          {|lead| lead.business.location_state}
            column("Business Phone")                 {|lead| GlobalPhone.parse(lead.business.phone_number).national_format unless lead.business.phone_number.nil?}
            column("Mobile Phone")                   {|lead| GlobalPhone.parse(lead.business.mobile_number).national_format unless lead.business.phone_number.nil?}
            column("Qulaification Type")             {|lead| status_tag(lead.qualification_type) }        
            column("Status")                         {|lead| status_tag(lead.state) }        
          end
        end
      end
    end 



    
  ### 
    #columns do
    #  column do
    #      panel 'New Businesses By Months' do
    #        @metric = Business.group(:email).count
    #        if Rails.env.production?
    #          @metric = Business.group_by_month(:created_at).count
    #        end
    #        render :partial => 'metrics/line_graph', :locals => {:metric => @metric}
    #      end
    #      panel 'Offers Accepted By Months' do
    #        @metric = Business.group(:email).count
    #        if Rails.env.production?
    #          @metric = Business.group_by_month(:created_at).count
    #        end
    #        render :partial => 'metrics/line_graph', :locals => {:metric => @metric}
    #      end
    #  end
    #  column do
    #      panel 'New Business By Day' do
    #        @metric = Business.group(:email).count
    #        if Rails.env.production?
    #          @metric = Business.group_by_day(:created_at).count
    #        end
    #        render :partial => 'metrics/line_graph', :locals => {:metric => @metric}
    #      end
    #      panel 'Offers Accepted By Day' do
    #        @metric = Business.group(:email).count
    #        if Rails.env.production?
    #          @metric = Business.group_by_day(:created_at).count
    #        end
    #        render :partial => 'metrics/line_graph', :locals => {:metric => @metric}
    #      end
    #  end
    #end
    section "Background Jobs" do
    now = Time.now.getgm
    ul do
      li do
        jobs = Delayed::Job.where('failed_at is not null').count(:id)
        link_to "#{jobs} failing jobs", grubraise_jobs_path(q: {failed_at_is_not_null: true}), style: 'color: red'
      end
      li do
        jobs = Delayed::Job.where('run_at <= ?', now).count(:id)
        link_to "#{jobs} late jobs", grubraise_jobs_path(q: {run_at_lte: now.to_s(:db)}), style: 'color: hsl(40, 100%, 40%)'
      end
      li do
        jobs = Delayed::Job.where('run_at >= ?', now).count(:id)
        link_to "#{jobs} scheduled jobs", grubraise_jobs_path(q: {run_at_gte: now.to_s(:db)}), style: 'color: green'
      end
    end
  end
end
    # Here is an example of a simple dashboard with columns and panels.
    #
    # columns do
    #   column do
    #     panel "Recent Posts" do
    #       ul do
    #         Post.recent(5).map do |post|
    #           li link_to(post.title, admin_post_path(post))
    #         end
    #       end
    #     end
    #   end

    #   column do
    #     panel "Info" do
    #       para "Welcome to ActiveAdmin."
    #     end
    #   end
    # end
   # content

  
end
