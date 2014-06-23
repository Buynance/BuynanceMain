require 'aggcat'

Aggcat.configure do |config|
  config.issuer_id = 'buynane.139503.cc.dev-intuit.ipp.prod'
  config.consumer_key = 'qyprdnaC8q89oMzdkui8ehwmSCONTR'
  config.consumer_secret = 'MfPmfUMU1PWT1pZ63L4picPScdrXQTO7hF1sZRjR'
  config.certificate_path = "#{Rails.root}/lib/assets/buynance_intuit.key"
  config.open_timeout = 10 # seconds
  config.read_timeout = 120 # seconds
end