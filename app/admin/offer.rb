ActiveAdmin.register Offer do

  filter :factor_rate
  filter :cash_advance_amount
  filter :daily_merchant_cash_advance
  filter :total_payback_amount
  filter :funder_id, label: "Funder", collection: proc { Funder.all}

  scope :all, :default => true
  scope :pending
  scope :removed
  scope :rejected
  scope :funded

  index do
    column("Offer", :sortable => :id)             {|offer| "##{offer.id} "}
    column("Business Name", :sortable => :business_id) {|offer| offer.lead.business.name}
    column("Funder")                              {|offer| offer.funder.name}  
    column("Cash Advance Amount")                 {|offer| number_to_currency offer.cash_advance_amount}
    column("Daily Collection")                    {|offer| number_to_currency offer.daily_merchant_cash_advance}
    column("Payback Amount")                      {|offer| number_to_currency offer.total_payback_amount}
    column("Factor Rate")                         {|offer| offer.factor_rate}
    column("Date", :created_at)
    actions
  end
end