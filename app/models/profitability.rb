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
  attr_accessible :monthly_cash_collection_amount, :gross_profit_margin, :total_month_fully_profitable_again,
    :total_monthly_bills, :daily_merchant_cash_advance, :projected_monthly_profit

  validates :monthly_cash_collection_amount, :gross_profit_margin, :total_month_fully_profitable_again,
    :total_monthly_bills, :daily_merchant_cash_advance, :projected_monthly_profit, presence: true

  validate :monthly_cash_should_be_greater_than_monthly_bills

  before_validation :calculate_daily_profit

  def calculate_daily_profit
    @pay_back = 0.2
    self.gross_profit_margin = (monthly_cash_collection_amount - total_monthly_bills)/monthly_cash_collection_amount
    self.projected_monthly_profit = ((monthly_cash_collection_amount - total_monthly_bills)/30 - (30 * daily_merchant_cash_advance)/20.8)*30

    # total_month_fully_profitable_again
    if monthly_cash_collection_amount == total_monthly_bills
      self.total_month_fully_profitable_again = -1   # don't care
    elsif projected_monthly_profit < 0
      val1 = projected_monthly_profit < -1 ? 6 : projected_monthly_profit > 1 ? 0 : 0
      val2 = (projected_monthly_profit * 6 / (monthly_cash_collection_amount - total_monthly_bills)).abs
      self.total_month_fully_profitable_again = (val1 + val2).abs.ceil
    else
      self.total_month_fully_profitable_again = 0
    end
  end

  def create_anonymous_user(ip)
    ip = '96.239.74.242' if ip == '127.0.0.1'
    new_user = AnonymousUser.find_or_initialize_by(ip: ip)
    new_user.ip = ip if (new_user.ip.nil? || new_user.ip.empty?)
    new_user.first_request = DateTime.now if (new_user.first_request.nil? || new_user.first_request.to_s.empty?)
    new_user.last_request = DateTime.now
    new_user.request_count = 0 if new_user.request_count.nil?
    new_user.request_count = new_user.request_count + 1
    new_user.state = "" if (new_user.state.nil? || new_user.state.empty?)
    is_set_location = (new_user.city.nil? || new_user.country.nil? || new_user.state.nil?) #|| new_user.city.empty? || new_user.country.empty? || new_user.state.empty?)
    if (is_set_location)
      location = AnonymousUser.get_location(ip)
      new_user.city = location[:city] if (new_user.city.nil? || new_user.city.empty?)
      new_user.state = location[:state] if (new_user.state.nil? || new_user.state.empty?)
      new_user.country = location[:country] if (new_user.country.nil? || new_user.country.empty?)
    else
      puts "=============================Can not find db or record for #{ip}"
    end
      new_user.save
  end

  private

    def monthly_cash_should_be_greater_than_monthly_bills
      errors.add(:total_monthly_bills, "should be less that the monthly cash collected") if total_monthly_bills > monthly_cash_collection_amount
    end
end
