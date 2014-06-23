namespace :institutions do
	desc "Updates the institution database"
	task :update => :enviroment do
		client.scope("123")
		
	end
	
end