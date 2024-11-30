FactoryBot.define do
  factory :entry, :class => Plutus::Entry do |entry|
    description { 'factory description' }
    factory :entry_with_credit_and_debit, :class => Plutus::Entry do
      after(:build) do |entry|
        entry.credit_amounts << FactoryBot.build(:credit_amount, entry: entry)
        entry.debit_amounts << FactoryBot.build(:debit_amount, entry: entry)
      end
    end
  end
end
