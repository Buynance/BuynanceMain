class TransactionsTypeCode < ActiveRecord::Base
  belongs_to :transaction
  belongs_to :type_code
end