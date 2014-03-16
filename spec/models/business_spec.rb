require 'spec_helper'

describe Business do
  let(:business){ Business.create earned_one_month_ago: 20000, earned_two_months_ago: 20000, earned_three_months_ago: 20000, password: "baconbits", password_confirmation: "baconbits", terms_of_service: true}

  describe "Create Business" do
  	business.should be_valid
  end

  # Is average over minimum should be valid

  #

end
