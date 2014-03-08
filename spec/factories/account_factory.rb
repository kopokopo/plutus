=begin
Factory.define :plutus_account do |account|
  account.name 'factory name'
  account.contra false
end

Factory.define :asset do |account|
  account.name 'factory name'
  account.contra false
end

Factory.define :equity do |account|
  account.name 'factory name'
  account.contra false
end

Factory.define :expense do |account|
  account.name 'factory name'
  account.contra false
end

Factory.define :liability do |account|
  account.name 'factory name'
  account.contra false
end

Factory.define :revenue do |account|
  account.name 'factory name'
  account.contra false
end

sequence :name do |n|
  "Factory Name #{n}"
end
=end


FactoryGirl.define do
  factory :account, :class => PlutusAccount do |account|
    account.name
    account.contra false
  end

  factory :asset, :class => Asset do |account|
    account.name
    account.contra false
  end

  factory :equity, :class => Equity do |account|
    account.name
    account.contra false
  end

  factory :expense, :class => Expense do |account|
    account.name
    account.contra false
  end

  factory :liability, :class => Liability do |account|
    account.name
    account.contra false
  end

  factory :revenue, :class => Revenue do |account|
    account.name
    account.contra false
  end

  sequence :name do |n|
    "Factory Name #{n}"
  end
end
