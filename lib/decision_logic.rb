require "net/https"
require "uri"

class DecisionLogic

	extend Savon::Model

	client wsdl: "http://www.decisionlogic.com/integration.asmx?WSDL"

	# Gets the function requested from decision logic url

	#client = Savon.client(wsdl: "http://www.decisionlogic.com/integration.asmx?wsdl")
	#client = Savon.client(wsdl: "http://rails-pc:8080/?WSDL")	

	def self.get_from_function(function, parameter_hash)
		return client.call(function.to_sym, message: parameter_hash).hash
	end

	def self.get_request_code
		return self.get("https://www.decisionlogic.com/CreateRequestCode.aspx?serviceKey=QBZKMWHRHND5&profileGuid=1db858e3-b4ad-44c2-a2da-6a000aa645b1&siteUserGuid=76246387-0c72-401a-b629-b5b102859bb3&customerId=&firstName=#{@business.first_name}&lastName=#{@business.last_name}&routingNumber=#{@business.bank_account.routing_number}&accountNumber=#{@business.bank_account.account_number}") 
		#return self.get("https://www.decisionlogic.com/CreateRequestCode.aspx?serviceKey=QBZKMWHRHND5&profileGuid=9538c1e4-2a44-4eca-9587-e5d5bd1fcf65&siteUserGuid=76246387-0c72-401a-b629-b5b102859bb3&customerId=&firstName=#{@business.first_name}&lastName=#{@business.last_name}&routingNumber=#{@business.bank_account.routing_number}&accountNumber=#{@business.bank_account.account_number}") 
	end

	def self.get(input_url)
		
		url = URI.parse(input_url)
		http = Net::HTTP.new(url.host, url.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_NONE
		req = Net::HTTP::Get.new(url.to_s)
		res = http.request(req)
		return res.body
	end

	def self.get_report_detail_from_request_code_4(request_code)
		service_key = Buynance::Application.config.service_key
		response = client.call(:get_report_detail_from_request_code4, message: { serviceKey: service_key, requestCode: request_code })
		report_detail_3 = response.body

		return report_detail_3[:get_report_detail_from_request_code4_response][:get_report_detail_from_request_code4_result]
	end

	def self.instant_refresh(request_code)
		service_key = Buynance::Application.config.service_key
		site_user_guid = Buynance::Application.config.site_user_guid
		response = client.call(:instant_refresh, message: { siteUserGuid: site_user_guid, serviceKey: service_key, requestCode: request_code })
		return response
	end

	def self.xml_to_ruby_datetime(xml_datetime)
		datetime = xml_datetime.split('T')
		date = datetime[0].split('-')
		time = datetime[1].split(':')
		return DateTime.new(date[0], date[1], date[2], time[0], time[1], time[2], '0')
	end

	def self.get_description_from_type_code(status_code)
		description = "Error: Code not found"
		description = "Payroll" if status_code == "py"
		description = "Loan Debit" if status_code == "ld"
		description = "Loan Credit" if status_code == "lc"
		description = "Overdraft" if status_code == "ov"
		description = "ACH Debit" if status_code == "ad"
		description = "ACH Credit" if status_code == "ac"
		description = "Deposit" if status_code == "dp"
		return description
	end

end