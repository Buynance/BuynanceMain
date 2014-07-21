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
        Offer.all.each do |offer|
            delinquent_id = 0
            if (offer.business_id == delinquent_id || Business.find_by(id: offer.business_id).nil?)
                delinquent_id = offer.business_id
                offer.destroy
            end
        end
    end

    desc "Add Business Types"
    task :add_business_types_sic => :environment do
        types = [ ["01", "Agricultural Production - Crops", "Agriculture, Forestry, & Fishing", "A"],
                  ["02", "Agricultural Production - Livestock", "Agriculture, Forestry, & Fishing", "A"],
                  ["07", "Agricultural Services", "Agriculture, Forestry, & Fishing", "A"],
                  ["08", "Forestry", "Agriculture, Forestry, & Fishing", "A"],
                  ["09", "Fishing, Hunting, & Trapping", "Agriculture, Forestry, & Fishing", "A"],
                  ["10", "Metal, Mining", "Mining", "B"],
                  ["12", "Coal Mining", "Mining", "B"],
                  ["13", "Oil & Gas Extraction", "Mining", "B"],
                  ["14", "Nonmetallic Minerals, Except Fuels", "Mining", "B"],
                  ["15", "General Building Contractors", "Construction", "C"],
                  ["16", "Heavy Construction, Except Building", "Construction", "C"],
                  ["17", "Special Trade Contractors", "Construction", "C"],
                  ["20", "Food & Kindred Products", "Manufacturing", "D"],
                  ["21", "Tobacco Products", "Manufacturing", "D"],
                  ["22", "Textile Mill Products", "Manufacturing", "D"],
                  ["23", "Apparel & Other Textile Products", "Manufacturing", "D"],
                  ["24", "Lumber & Wood Products", "Manufacturing", "D"],
                  ["25", "Furniture & Fixtures", "Manufacturing", "D"],
                  ["26", "Paper & Allied Products", "Manufacturing", "D"],
                  ["27", "Printing & Publishing", "Manufacturing", "D"],
                  ["28", "Chemical & Allied Products", "Manufacturing", "D"],
                  ["29", "Petroleum & Coal Products", "Manufacturing", "D"],
                  ["30", "Rubber & Miscellaneous Plastics Products", "Manufacturing", "D"],
                  ["31", "Leather & Leather Products", "Manufacturing", "D"],
                  ["32", "Stone, Clay, & Glass Products", "Manufacturing", "D"],
                  ["33", "Primary Metal Industries", "Manufacturing", "D"],
                  ["34", "Fabricated Metal Products", "Manufacturing", "D"],
                  ["35", "Industrial Machinery & Equipment", "Manufacturing", "D"],
                  ["36", "Electronic & Other Electric Equipment", "Manufacturing", "D"],
                  ["37", "Transportation Equipment", "Manufacturing", "D"],
                  ["38", "Instruments & Related Products", "Manufacturing", "D"],
                  ["39", "Miscellaneous Manufacturing Industries", "Manufacturing", "D"],
                  ["40", "Railroad Transportation", "Transportation & Public Utilities", "E"],
                  ["41", "Local & Interurban Passenger Transit", "Transportation & Public Utilities", "E"],
                  ["42", "Trucking & Warehousing", "Transportation & Public Utilities", "E"],
                  ["43", "U.S. Postal Service", "Transportation & Public Utilities", "E"],
                  ["44", "Water Transportation", "Transportation & Public Utilities", "E"],
                  ["45", "Transportation by Air", "Transportation & Public Utilities", "E"],
                  ["46", "Pipelines, Except Natural Gas", "Transportation & Public Utilities", "E"],
                  ["47", "Transportation Services", "Transportation & Public Utilities", "E"],
                  ["48", "Communications", "Transportation & Public Utilities", "E"],
                  ["49", "Electric, Gas, & Sanitary Services", "Transportation & Public Utilities", "E"],
                  ["50", "Wholesale Trade - Durable Goods", "Wholesale Trade", "F"],
                  ["51", "Wholesale Trade - Nondurable Goods", "Wholesale Trade", "F"],
                  ["52", "Building Materials & Gardening Supplies", "Retail Trade", "G"],
                  ["53", "General Merchandise Stores", "Retail Trade", "G"],
                  ["54", "Food Stores", "Retail Trade", "G"],
                  ["55", "Automative Dealers & Service Stations", "Retail Trade", "G"],
                  ["56", "Apparel & Accessory Stores", "Retail Trade", "G"],
                  ["57", "Furniture & Homefurnishings Stores", "Retail Trade", "G"],
                  ["58", "Eating & Drinking Places", "Retail Trade", "G"],
                  ["59", "Miscellaneous Retail", "Retail Trade", "G"],
                  ["60", "Depository Institutions", "Finance, Insurance, & Real Estate", "H"],
                  ["61", "Nondepository Institutions", "Finance, Insurance, & Real Estate", "H"],
                  ["62", "Security & Commodity Brokers", "Finance, Insurance, & Real Estate", "H"],
                  ["63", "Insurance Carriers", "Finance, Insurance, & Real Estate", "H"],
                  ["64", "Insurance Agents, Brokers, & Service", "Finance, Insurance, & Real Estate", "H"],
                  ["65", "Real Estate", "Finance, Insurance, & Real Estate", "H"],
                  ["67", "Holding & Other Investment Offices", "Finance, Insurance, & Real Estate", "H"],
                  ["70", "Hotels & Other Lodging Places", "Services", "I"],
                  ["72", "Personal Services", "Services", "I"],
                  ["73", "Business Services", "Services", "I"],
                  ["75", "Auto Repair, Services, & Parking", "Services", "I"],
                  ["76", "Miscellaneous Repair Services", "Services", "I"],
                  ["78", "Motion Pictures", "Services", "I"],
                  ["79", "Amusement & Recreation Services", "Services", "I"],
                  ["80", "Health Services", "Services", "I"],
                  ["81", "Legal Services", "Services", "I"],
                  ["82", "Educational Services", "Services", "I"],
                  ["83", "Social Services", "Services", "I"],
                  ["84", "Museums, Botanical, Zoological Gardens", "Services", "I"],
                  ["86", "Membership Organizations", "Services", "I"],
                  ["87", "Engineering & Management Services", "Services", "I"],
                  ["88", "Private Households", "Services", "I"],
                  ["89", "Services, Not Elsewhere Classified", "Services", "I"],
                  ["91", "Executive, Legislative, & General", "Public Administration", "J"],
                  ["92", "Justice, Public Order, & Safety", "Public Administration", "J"],
                  ["93", "Finance, Taxation, & Monetary Policy", "Public Administration", "J"],
                  ["94", "Administration of Human Resources", "Public Administration", "J"],
                  ["95", "Environmental Quality & Housing", "Public Administration", "J"],
                  ["96", "Administration of Economic Programs", "Public Administration", "J"],
                  ["97", "National Security & International Affairs", "Public Administration", "J"],
                  ["98", "Zoological Gardens", "Public Administration", "J"],
                  ["99", "Non-Classifiable Establishments", "Nonclassifiable Establishments", "K"]
                ]

        length = types.length

        (0..length).each do |value|
            business_type_division = BusinessTypeDivisions.find_or_create_by(name: types[value][2], division_code: types[value][3])
            business_type = BusinessType.create(name: types[value][1], sic_code_two: types[value][0], business_type_division_id: business_type_division.id)
        end
    end
    

    desc "Add Business Types"
    task :add_business_types => :environment do
        BusinessType.destroy_all
        types = [ 
                  ["Administrative and Support Services"],
                  ["Agriculture"],
                  ["Arts, Entertainment, and Recreation"],
                  ["Automobile Dealers"],
                  ["Automotive Repair and Maintenance"],
                  ["Business Services"],
                  ["Construction"],
                  ["Educational Services"],
                  ["Finance and Insurance"],
                  ["Forestry, Fishing, and Hunting"],
                    ["Freight Trucking"],
                    ["Gambling Industries"],
                    ["Gas Stations"],
                    ["Greenhouse, Nursery, and Floriculture"],
                    ["Healthcare and Social Assistance"],
                    ["Hotels and Travel Accomodations"],
                    ["Information and Technology"],
                    ["Legal Services"],
                    ["Management of Companies"],
                    ["Manufacturing"],
                    ["Mining"],
                    ["Non-Profit Organizations"],
                    ["Personal Care Services"],
                    ["Physician, Dentist, or Health Practitioner"],
                    ["Public Administration"],
                    ["Real Estate"],
                    ["Religious Institutions"],
                    ["Rental and Leasing"],
                    ["Restaurants and Food Services"],
                    ["Retail Stores"],
                    ["Transportation"],
                    ["Utilities"],
                    ["Veterinarians"],
                    ["Warehousing and Storage"],
                    ["Waste Management &amp; Remediation Services"],
                    ["Wholesale Trade"],
                    ["Professional, Scientific, and Technical Services"],
                    ["Other Services"]
                ]

        length = types.length

        (0...length).each do |value|
            business_type = BusinessType.create(name: types[value][0])
        end
    end 

    desc "Add Past Funder"
    task :add_previous_funder => :environment do
        CashAdvanceCompany.destroy_all
        companies = [ ["1st Merchant Funding"],
                      ["AdvanceMe"],
                      ["American Finance Solutions"],
                      ["American Capital Advance"],
                      ["AmeriMerchant"],
                      ["Arch Capital Funding"],
                      ["Bankcard Funding"],
                      ["BizFunds"],
                      ["The Business Backer"],
                      ["Business Consulting Options"],
                      ["Business Financial Services"],
                      ["Capital For Merchants"],
                      ["Centerboard Funding"],
                      ["Express Working Capital"],
                      ["Factor Funding"],
                      ["First Funds"],
                      ["Genesis Capital Enterprises"],
                      ["Green Growth Funding"],
                      ["Greystone Business Resources"],
                      ["GRP Funding"],
                      ["Happy Rock Merchant Solutions"],
                      ["Infinity Capital Funding"],
                      ["Max Advance"],
                      ["Max Merchant Funding"],
                      ["Merchant Advance Funding LP"],
                      ["Merchant Cash Advance of Texas"],
                      ["Merchant Cash and Capital"],
                      ["Merchant Cash Funding"],
                      ["Merchant Cash Group"],
                      ["Merchants Capital Access"],
                      ["Merchant Capital Source"],
                      ["Merchant Resources International"],
                      ["Money For Merchants"],
                      ["Mother Fund"],
                      ["Pinnacle Merchant Advance"],
                      ["Professional Merchant Advance Capital"],
                      ["Quick Cash Business Services"],
                      ["RapidAdvance"],
                      ["Smart Choice Capital"],
                      ["Sterling Funding"],
                      ["Strategic Funding Source"],
                      ["Snap Advances"],
                      ["EZ Business Cash Advance"],
                      ["Other"]
                    ]

        length = companies.length

        (0...length).each do |value|
            CashAdvanceCompany.create(name: companies[value][0])
        end
    end

    desc "Import Translation File"
    task :import_translation => :environment do
       

    end
end