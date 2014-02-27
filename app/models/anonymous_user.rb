class AnonymousUser < ActiveRecord::Base
	def self.get_location(ip)
      db = MaxMindDB.new(Rails.root.join('app', 'geolite', 'db', 'GeoLite2-City.mmdb').to_s)
      record = db.lookup(ip)
      return_val = {city: "", state: "", country: ""}
      if record 
        country_name = record['country']['names']['en']
        city_name = record['city']['names']['en']
        #puts "=====================#{record['region']}"
        #state_name = record['region']['names']['en']

        return_val = {city: city_name,  country: country_name}
      else
      end	
      return_val
	end
end
