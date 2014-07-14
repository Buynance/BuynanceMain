require 'mixpanel-ruby'

class MixpanelLib

	@tracker = Mixpanel::Tracker.new("88eadcd5c08e6706ccae6eb427c0ec6a")

	def self.track(user_id, event, profile_hash = false)
		unless profile_hash == false
    		@tracker.track(user_id, event, profile_hash)
    	else
    		@tracker.track(user_id, event)
    	end
    end
end