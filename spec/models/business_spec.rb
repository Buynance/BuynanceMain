require 'spec_helper'


describe Business do

  it "Business deposits average over minimum should be valid" do
    FactoryGirl.build(:business, :deposit_over_minimum).should be_valid
  end

  it "Business deposits average under minimum should be not qualified" do
    FactoryGirl.build(:business, :deposit_under_minimum).qualified?.should == false
  end

  it "Business should pass financial step" do
    FactoryGirl.build(:business, :valid_financial_inputs).should be_valid
  end

  it "Business under one year should not qualify" do
    FactoryGirl.build(:business, :one_year_old_and_under).qualified?.should == false
  end

  it "Business with credit score under minimum should not qualify" do
    FactoryGirl.build(:business, :minimum_credit_score).qualified?.should == false
  end

  it "Business with tax lien and is not paying back should not qualify" do
    FactoryGirl.build(:business, :is_tax_lien_and_not_paying_back).qualified?.should == false
  end

  it "Business with bankruptcy should not qualify" do
    FactoryGirl.build(:business, :with_bankruptcy).qualified?.should == false
  end

  it "Business with judgement should not qualify" do
    FactoryGirl.build(:business, :with_judgement).qualified?.should == false
  end

  it "Business with amount negative greater than three should not qualify" do
    FactoryGirl.build(:business, :amount_negative_higher_than_three).qualified?.should == false
  end

  it "Business should pass funder step" do
    FactoryGirl.build(:business, :valid_financial_inputs).should be_valid
  end

  it "Business who have not paid atleast 40% should not qualify" do
    FactoryGirl.build(:business, :payback_amount_less_than_60_percent).qualified?.should == 40
  end

end
