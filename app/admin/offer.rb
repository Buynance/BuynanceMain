ActiveAdmin.register Offer do
  actions :index

  filter :factor_rate
  filter :cash_advance_amount
  filter :daily_merchant_cash_advance
  filter :total_payback_amount
  filter :factor_rate

  scope :all, :default => true
  scope :active
  scope :inactive
  scope :best_offers

  index do
    column("Offer", :sortable => :id)             {|offer| "##{offer.id} "}
    column("Active")                              {|offer| offer.is_active }
    column("Best Offer")                          {|offer| offer.is_best_offer }
    column("Date", :created_at)
    column("Customer", :sortable => :business_id) {|offer| BusinessUser.find(business_id: Business.find(offer.business_id, no_obfuscated_id: true).id).email if !Business.find(offer.business_id, no_obfuscated_id: true).nil?}
    column("Cash Advance Amount")                 {|offer| number_to_currency offer.cash_advance_amount}
    column("Daily Collection")                    {|offer| number_to_currency offer.daily_merchant_cash_advance}
    column("Payback Amount")                      {|offer| number_to_currency offer.total_payback_amount}
    column("Factor Rate")                         {|offer| offer.factor_rate}
  end
end