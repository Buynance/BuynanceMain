require 'spec_helper'

describe Transaction do
  
  describe "#deposits" do
  	it "should return all deposits" do
  		deposit_code = TypeCode.create(type_code: "dp")
  		credit_code = TypeCode.create(type_code: "ac")
  		transactions = Array.new
  		transactions[0] = Transaction.create()
  		transactions[0].type_codes << deposit_code
  		transactions[1] = Transaction.create()
  		transactions[1].type_codes << deposit_code
  		transactions[2] = Transaction.create()
  		transactions[2].type_codes << credit_code
  		transactions[3] = Transaction.create()
  		transactions[3].type_codes << deposit_code
  		transactions[4] = Transaction.create()
  		transactions[4].type_codes << credit_code
  		transactions[5] = Transaction.create()
  		transactions[5].type_codes << credit_code
  		expect(Transaction.get_transactions_by_type_from_array(transactions, "dp").size).to eq(3)
  	end
  end
end
