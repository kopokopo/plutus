Factory.define :amount do |amount|
  amount.amount BigDecimal.new('473')
  amount.association :transaction, :factory => :transaction_with_credit_and_debit
  amount.association :plutus_account, :factory => :asset
end

Factory.define :credit_amount do |credit_amount|
  credit_amount.amount BigDecimal.new('473')
  credit_amount.association :transaction, :factory => :transaction_with_credit_and_debit
  credit_amount.association :plutus_account, :factory => :revenue
end

Factory.define :debit_amount do |debit_amount|
  debit_amount.amount BigDecimal.new('473')
  debit_amount.association :transaction, :factory => :transaction_with_credit_and_debit
  debit_amount.association :plutus_account, :factory => :asset
end