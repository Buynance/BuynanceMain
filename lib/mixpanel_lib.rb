require 'mixpanel-ruby'

class MixpanelLib

	@tracker = Mixpanel::Tracker.new("bbc45e2f3c28a249e4b7dd39ad78ac2a")

	def self.track(user_id, event, profile_hash = false)
		unless profile_hash == false
    		@tracker.track(user_id, event, profile_hash)
    	else
    		@tracker.track(user_id, event)
    	end
    end
end