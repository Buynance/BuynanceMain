namespace :db do
    desc "Migrate Businesses to Business Users"
    task :create_business_users => :environment do
    	Business.all.each do |business|
    		business_user = BusinessUser.find_or_initialize_by(email: business.email)
    		business_user.crypted_password = business.crypted_password
            business_user.recovery_code = business.recovery_code
            business_user.password_salt = business.password_salt
            business_user.last_name = business.owner_last_name
            business_user.mobile_number = business.mobile_number
            business_user.business_id = business.id
    		business_user.save(validate: false)
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
              elsif business.is_finished_application
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
            business.save
        end
    end

    desc "Recreate All Offers"
    task :recreate_offers => :environment do
        Business.all.each do |business|
            business.offers.destroy_all
            if (business.state != "awaiting_information" and business.state != "declined")
                business.main_offer_id = nil
                business.create_offers(12)
                business.save
            end
        end
    end

    desc "Recreate All Offers"
    task :destroy_delinquent_offers => :environment do
        Offer.all.each do |business|
            delinquent_id = 0
            if (offer.business_id == delinquent_id || Business.find(Offer.business_id, no_obfuscated_id: true).nil?)
                delinquent_id = offer.business_id
                offer.destroy
            end
        end
    end
     
end