# == Schema Information
#
# Table name: profitabilities
#
#  id                           :integer          not null, primary key
#  daily_cash_collection_amount :float
#  gross_profit_margin          :float
#  projected_daily_profit       :float
#  created_at                   :datetime
#  updated_at                   :datetime
#

class Profitability < ActiveRecord::Base
  attr_accessible :daily_cash_collection_amount, :gross_profit_margin, 
    :projected_daily_profit

  validates :daily_cash_collection_amount, :gross_profit_margin, 
    :projected_daily_profit, presence: true

  before_validation :calculate_daily_profit

  def calculate_daily_profit
    @pay_back = 0.2
    self.projected_daily_profit = (daily_cash_collection_amount/@pay_back)*(gross_profit_margin/100) - daily_cash_collection_amount
  end
end