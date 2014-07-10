ActiveAdmin.register_page "Dashboard" do

  menu :priority => 1, :label => proc{ I18n.t("active_admin.dashboard") }

   content do
    columns do
      
      column do
        panel "Last 10 Businesses" do
          table_for Business.order('id desc').limit(10).each do |business|
            column("Business", :sortable => :id) {|business| link_to "##{business.id}", grubraise_business_path(business)}
            column("State")                      {|business| status_tag(business.state) }
            column("Email")                      {|business| link_to business.email, grubraise_business_user_path(BusinessUser.find_by(email: business.email))}
          end
        end
      end

      column do
        panel "Last 10 Leads" do
          table_for Lead.order('id desc').limit(10).each do |lead|
            column("Business", :sortable => :id) {|business| link_to "##{business.id}", grubraise_business_path(business)}
            column("State")                      {|business| status_tag(business.state) }
            # column("Email")                     {|business| link_to business.email, grubraise_business_user_path(BusinessUser.find_by(email: business.email))}
          end
        end
      end


    end 
    columns do
      column do
        panel "Last 10 Leads" do
          table_for Lead.order('id desc').limit(10).each do |lead|
            column("Business", :sortable => :id) {|business| link_to "##{business.id}", grubraise_business_path(business)}
            column("State")                      {|business| status_tag(business.state) }
            # column("Email")                     {|business| link_to business.email, grubraise_business_user_path(BusinessUser.find_by(email: business.email))}
          end
        end
      end
      column do
        panel "Statistics" do
          #column("Number of Business") {||}

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
