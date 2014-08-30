require "net/https"
require "uri"

class Zoho

	def self.send_business(auth_key, business)
		"https://crm.zoho.com/crm/private/xml/Leads/insertRecords?newFormat=1&authtoken=Auth Token&scope=crmapi"
	end

end

# Lead Inputs
# Field Name 	     API Format 	   Data type 	Maximum Limit
# Lead Owner 	     Lead Owner 	   Lookup 	    -
# Salutation 	     Salutation 	   Pick list 	-
# First Name 	     First Name 	   Text box 	Alphanumeric(40)
# Title	             Title             Text box 	Alphanumeric(100)
# Last Name* 	     Last Name* 	   Text box 	Alphanumeric(80)
# Company* 	         Company* 	       Text box 	Alphanumeric(100)
# Lead Source 	     Lead Source 	   Pick list 	-
# Industry 	         Industry 	       Pick list 	-
# Annual Revenue     Annual Revenue    Currency 	Decimal (16)
# Phone	             Phone 	           Text box 	Alphanumeric(30)
# Mobile 	         Mobile 	       Text box 	Alphanumeric(30)
# Fax 	             Fax 	           Text box 	Alphanumeric(30)
# Email	             Email 	           Email 	    Alphanumeric and Special characters(100)
# Sec Email	         Secondary Email   Email 	    Alphanumeric and Special characters(100)
# Skype ID	         Skype ID 	       Text box 	Alphanumeric(50)
# Website 	         Website 	       URL       	Alphanumeric(120)
# Lead Status 	     Lead Status 	   Pick list 	-
# Rating 	         Rating 	       Pick list 	-
# No. Employees	     No. of Employees  Numeric 	    Integer (16)
# Email Opt-out	     Email Opt-out 	   Check box 	-
# Campaign Src 	     Campaign Source   Lookup 	    -
# Street 	         Street 	       Text box     Alphanumeric(250)
# City 	             City 	           Text box 	Alphanumeric(30)
# State	             State 	           Text box 	Alphanumeric(30)
# Zip Code 	         Zip Code 	       Numeric 	    Alphanumeric(30)
# Country 	         Country 	       Text box 	Alphanumeric(30)
# Description 	     Description 	   Text area 	32000 characters