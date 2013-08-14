Factory.define :transaction do |transaction|
  #transaction.description 'factory description'
  #transaction.credit_account {|credit_account| credit_account.association(:asset)}
  #transaction.debit_account {|debit_account| debit_account.association(:revenue)}
  #transaction.amount BigDecimal.new('100')

  transaction.description 'factory description'
  factory :transaction_with_credit_and_debit, :class => Transaction do |transaction_cd|
    transaction_cd.after_build do |t|
      t.credit_amounts << Factory.build(:credit_amount, :transaction => t)
      t.debit_amounts << Factory.build(:debit_amount, :transaction => t)
    end
  end
end