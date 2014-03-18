require 'spec_helper'


describe Business do
  let(:business){ Business.create earned_one_month_ago: 20000, earned_two_months_ago: 20000, earned_three_months_ago: 20000, password: "baconbits", password_confirmation: "baconbits", terms_of_service: true}

  describe "Create Business" do
  	it "Should create with basic information" do
  		business1 = Business.new earned_one_month_ago: 20000, earned_two_months_ago: 20000, earned_three_months_ago: 20000, email: "edwin.velaquez@gmail.com", password: "ed001967", password_confirmation: "ed001967", terms_of_service: "1"
  		cookies = Hash.new
  		cookies['user_credentials'] = "#{business1.persistence_token}::#business1.send(business1.class.primary_key)}"
  		business1.save
  		business1.should be_valid
  	end

  	it "Should not be valid without terms" do
   		business1 = Business.new earned_one_month_ago: 20000, earned_two_months_ago: 20000, earned_three_months_ago: 20000, email: "edwin.velaquez@gmail.com", password: "ed001967", password_confirmation: "ed001967", terms_of_service: "1"
  		business1.save
  		business1.should_not be_valid
    end
  end

  # Is average over minimum should be valid

  #

end
