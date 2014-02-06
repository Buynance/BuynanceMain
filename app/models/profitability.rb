# == Schema Information
#
# Table name: profitabilities
#
#  id                             :integer          not null, primary key
#  monthly_cash_collection_amount :float
#  gross_profit_margin            :float
#  projected_monthly_profit       :float
#  created_at                     :datetime
#  updated_at                     :datetime
#  total_monthly_bills            :float
#  daily_merchant_cash_advance    :float
#

class Profitability < ActiveRecord::Base
  attr_accessible :monthly_cash_collection_amount, :gross_profit_margin, 
    :total_monthly_bills, :daily_merchant_cash_advance, :projected_monthly_profit

  validates :monthly_cash_collection_amount, :gross_profit_margin, 
    :total_monthly_bills, :daily_merchant_cash_advance, :projected_monthly_profit, presence: true

  before_validation :calculate_daily_profit

  def calculate_daily_profit
    @pay_back = 0.2
    self.gross_profit_margin = (monthly_cash_collection_amount - total_monthly_bills)/monthly_cash_collection_amount
    self.projected_monthly_profit = ((monthly_cash_collection_amount - total_monthly_bills)/30 - (30 * daily_merchant_cash_advance)/20.8)*30
  end
end
