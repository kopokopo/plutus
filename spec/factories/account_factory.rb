FactoryBot.define do
  factory :account, class: Plutus::Account do
    name { FactoryBot.generate(:name) }
    contra { false }
  end

  factory :asset, class: Plutus::Asset do
    name { FactoryBot.generate(:name) }
    contra { false }
  end

  factory :equity, class: Plutus::Equity do
    name { FactoryBot.generate(:name) }
    contra { false }
  end

  factory :expense, class: Plutus::Expense do
    name { FactoryBot.generate(:name) }
    contra { false }
  end

  factory :liability, class: Plutus::Liability do
    name { FactoryBot.generate(:name) }
    contra { false }
  end

  factory :revenue, class: Plutus::Revenue do
    name { FactoryBot.generate(:name) }
    contra { false }
  end

  sequence :name do |n|
    "Factory Name #{n}"
  end
end
