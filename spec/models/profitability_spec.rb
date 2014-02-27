require 'spec_helper'

describe Profitability do
  it "should_be_less_and_not_valid" do
  	FactoryGirl.build(:profitability, :monthly_collected_less_than_monthly_total).should_not be_valid
  end
end
