class BusinessSession < Authlogic::Session::Base
	before_destroy :reset_persistence_token
    before_create  :reset_persistence_token

    def reset_persistence_token
        record.reset_persistence_token
    end 

end
