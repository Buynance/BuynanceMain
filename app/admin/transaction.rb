ActiveAdmin.register Transaction do

	index do
	end
	
	csv do
		column("Date", :sortable => :transaction_date) {|transaction| transaction.transaction_date.strftime("%m/%d/%Y")}
        column("Amount", :sortable => :amount)         {|transaction| ActionController::Base.helpers.number_to_currency transaction.amount}
        column("Type")                                 {|transaction| transaction.type_code}
        column(:description)                           {|transaction| transaction.description}
        column(:running_balance)                       {|transaction| ActionController::Base.helpers.number_to_currency transaction.running_balance}   
  	end
end