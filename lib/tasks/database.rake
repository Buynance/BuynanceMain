namespace :db do
    desc "Migrate Businesses to Business Users"
    task :create_business_users => :environment do
    	Business.all.each do |business|
    		business_user = BusinessUser.find_or_initialize_by(email: business.email)
    		business_user.password = business.password
    		business_user.password_confirmation = business.password
            business_user.first_name = business.owner_first_name
            business_user.last_name = business.owner_last_name
            business_user.mobile_number = business.mobile_number
    		business_user.save
    		business.main_business_user_id = business_user.id
    		business.save
    	end
    end

    desc "Add Business States"
    task :add_business_states => :environment do
        Business.all.each do |business|
            business.state = "awaiting_information"
            if !business.is_email_confirmed
              if !business.qualified?
                business.decline
              else
                business.update_account_information
              end
            else
                business.update_account_information
                business.comfirm_account
                if !business.main_offer_id.nil?
                    business.accept_offer
                end
                if !business.owner_first_name.nil?
                    business.submit_offer
                end

            end 
        end
    end

     
end