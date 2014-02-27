class AnonymousUserWorker
  include Sidekiq::Worker
  sidekiq_options retry: false
  
  def perform(ip, profitability_id)
    profitability = Profitability.find_by_id(profitability_id)
  	profitability.create_anonymous_user(ip)  
  end
end