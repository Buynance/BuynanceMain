require 'spec_helper'
require 'pp'

describe BankAccount do

  describe "#map_hash" do
  	it "should reverse the hash" do
  		bank_account = BankAccount.new
  		hash = {cool_bean: "CoolBean", cool_cat: "CoolCat", cool_dude: "CoolDude"}
  		hash_mapped = {cool_bean: "coolBean", cool_cat: "coolCat", cool_dude: "coolDude"}
  		expected_hash = {coolBean: "CoolBean", coolCat: "CoolCat", coolDude: "CoolDude"}
  		hash = bank_account.send(:map_hash, hash, hash_mapped)
      pp hash
  		expect(hash).to eq(expected_hash)
  	end
  end

  describe "#get_negative_days_from_transactions" do
    it "should count negatives days" do
      bank_account = BankAccount.new
      transaction_array = Array.new
      transaction_array << Transaction.new(transaction_date: DateTime.now, running_balance: -500)
      transaction_array << Transaction.new(transaction_date: DateTime.now, running_balance: -500)
      transaction_array << Transaction.new(transaction_date: DateTime.now, running_balance: 500)
      transaction_array << Transaction.new(transaction_date: DateTime.now << 1, running_balance: 500)
      transaction_array << Transaction.new(transaction_date: DateTime.now << 2, running_balance: -500)
      transaction_array << Transaction.new(transaction_date: DateTime.now << 3, running_balance: 500)
      transaction_array << Transaction.new(transaction_date: DateTime.now << 4, running_balance: 500)
      transaction_array << Transaction.new(transaction_date: DateTime.now << 5, running_balance: -500)

      count = bank_account.send(:get_negative_days_from_transactions,transaction_array)
      expect(count).to eq(3)
    end
  end

  describe "#transaction_count_past_x_month" do
    it "should count transactions" do
      bank_account = BankAccount.new
      transaction_array = Array.new
      transaction_array << Transaction.new(transaction_date: DateTime.now)
      transaction_array << Transaction.new(transaction_date: (DateTime.now - 1))
      transaction_array << Transaction.new(transaction_date: (DateTime.now - 2))
      transaction_array << Transaction.new(transaction_date: (DateTime.now - 3))
      transaction_array << Transaction.new(transaction_date: (DateTime.now - 4))
      transaction_array << Transaction.new(transaction_date: (DateTime.now << 1))
      transaction_array << Transaction.new(transaction_date: ((DateTime.now << 1) - 1))
      transaction_array << Transaction.new(transaction_date: ((DateTime.now << 1) - 2))
      transaction_array << Transaction.new(transaction_date: ((DateTime.now << 1) - 3))
      transaction_array << Transaction.new(transaction_date: ((DateTime.now << 1) - 4))
      transaction_array << Transaction.new(transaction_date: (DateTime.now << 2))
      transaction_array << Transaction.new(transaction_date: ((DateTime.now << 2) - 1))
      transaction_array << Transaction.new(transaction_date: ((DateTime.now << 2) - 2))
      transaction_array << Transaction.new(transaction_date: ((DateTime.now << 2) - 3))
      transaction_array << Transaction.new(transaction_date: ((DateTime.now << 2) - 4))
      transaction_array << Transaction.new(transaction_date: (DateTime.now << 3))
      transaction_array << Transaction.new(transaction_date: ((DateTime.now << 3) - 1))
      transaction_array << Transaction.new(transaction_date: ((DateTime.now << 3) - 2))
      transaction_array << Transaction.new(transaction_date: ((DateTime.now << 3) - 3))
      transaction_array << Transaction.new(transaction_date: ((DateTime.now << 3) - 4))

      count_array = bank_account.send(:transaction_count_past_x_month, 3, transaction_array)
      expect(count_array).to eq([5,5,5])
    end
  end

  describe "#average_deosit_last_x_months_deposit" do
    it "should get the average of the las x monts" do
      bank_account = BankAccount.new
      transaction_array = Array.new
      deposit_type = TypeCode.new(type_code: "dp", description: "Deposit")
      debit_type = TypeCode.new(type_code: "ad", description: "Debits")
      transaction_array << Transaction.new(transaction_date: DateTime.now, amount: 500)
      transaction_array[0].type_codes << deposit_type 
      transaction_array << Transaction.new(transaction_date: (DateTime.now - 1), amount: 500)
      transaction_array[[1]].type_codes << deposit_type 
      transaction_array << Transaction.new(transaction_date: (DateTime.now - 2))
      transaction_array << Transaction.new(transaction_date: (DateTime.now - 3))
      transaction_array << Transaction.new(transaction_date: (DateTime.now - 4))
      transaction_array << Transaction.new(transaction_date: (DateTime.now << 1))
      transaction_array << Transaction.new(transaction_date: ((DateTime.now << 1) - 1))
      transaction_array << Transaction.new(transaction_date: ((DateTime.now << 1) - 2))
      transaction_array << Transaction.new(transaction_date: ((DateTime.now << 1) - 3))
      transaction_array << Transaction.new(transaction_date: ((DateTime.now << 1) - 4))
      transaction_array << Transaction.new(transaction_date: (DateTime.now << 2))
      transaction_array << Transaction.new(transaction_date: ((DateTime.now << 2) - 1))
      transaction_array << Transaction.new(transaction_date: ((DateTime.now << 2) - 2))
      transaction_array << Transaction.new(transaction_date: ((DateTime.now << 2) - 3))
      transaction_array << Transaction.new(transaction_date: ((DateTime.now << 2) - 4))
      transaction_array << Transaction.new(transaction_date: (DateTime.now << 3))
      transaction_array << Transaction.new(transaction_date: ((DateTime.now << 3) - 1))
      transaction_array << Transaction.new(transaction_date: ((DateTime.now << 3) - 2))
      transaction_array << Transaction.new(transaction_date: ((DateTime.now << 3) - 3))
      transaction_array << Transaction.new(transaction_date: ((DateTime.now << 3) - 4))

      count_array = bank_account.send(:transaction_count_past_x_month, 3, transaction_array)
      expect(count_array).to eq([5,5,5])
    end
  end

end
