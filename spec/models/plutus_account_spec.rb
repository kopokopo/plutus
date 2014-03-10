require 'spec_helper'

=begin
describe PlutusAccount do
  
  it "should not allow creating an account without a subtype" do
    account = Factory.build(:account)
    account.should_not be_valid
  end
  
  it "should not have a balance method" do
    lambda{PlutusAccount.balance}.should raise_error(NoMethodError)
  end
  
  it "should have a trial balance" do
    PlutusAccount.should respond_to(:trial_balance)
    PlutusAccount.trial_balance.should be_kind_of(BigDecimal)
  end
  
  it "should report a trial balance of 0 with correct transactions" do
    # credit plutus_accounts
    liability = Factory(:liability)
    equity = Factory(:equity)
    revenue = Factory(:revenue)
    contra_asset = Factory(:asset, :contra => true)
    contra_expense = Factory(:expense, :contra => true)

    # debit plutus_accounts
    asset = Factory(:asset)
    expense = Factory(:expense)
    contra_liability = Factory(:liability, :contra => true)
    contra_equity = Factory(:equity, :contra => true)
    contra_revenue = Factory(:revenue, :contra => true)
    
    Factory(:transaction, :credit_account =>  liability, :debit_account => asset, :amount => 100000)
    Factory(:transaction, :credit_account =>  equity, :debit_account => expense, :amount => 1000)
    Factory(:transaction, :credit_account =>  revenue, :debit_account => contra_liability, :amount => 40404)
    Factory(:transaction, :credit_account =>  contra_asset, :debit_account => contra_equity, :amount => 2)
    Factory(:transaction, :credit_account =>  contra_expense, :debit_account => contra_revenue, :amount => 333)

    PlutusAccount.trial_balance.should == 0
  end

end


=end



module Plutus
  describe PlutusAccount do
    let(:plutus_account) { FactoryGirl.build(:plutus_account) }
    subject { plutus_account }

    it { should_not be_valid }  # must construct a child type instead

    describe "when using a child type" do
      let(:plutus_account) { FactoryGirl.create(:plutus_account, type: "Finance::Asset") }
      it { should be_valid }

      it "should be unique per name" do
        conflict = FactoryGirl.build(:plutus_account, name: plutus_account.name, type: plutus_account.type)
        conflict.should_not be_valid
        conflict.errors[:name].should == ["has already been taken"]
      end
    end

    it { should_not respond_to(:balance) }

    describe ".trial_balance" do
      subject { PlutusAccount.trial_balance }
      it { should be_kind_of BigDecimal }

      context "when given no transactions" do
        it { should == 0 }
      end

      context "when given correct transactions" do
        before {
          # credit accounts
          liability = FactoryGirl.create(:liability)
          equity = FactoryGirl.create(:equity)
          revenue = FactoryGirl.create(:revenue)
          contra_asset = FactoryGirl.create(:asset, :contra => true)
          contra_expense = FactoryGirl.create(:expense, :contra => true)
          # credit amounts
          ca1 = FactoryGirl.build(:credit_amount, :plutus_account => liability, :amount => 100000)
          ca2 = FactoryGirl.build(:credit_amount, :plutus_account => equity, :amount => 1000)
          ca3 = FactoryGirl.build(:credit_amount, :plutus_account => revenue, :amount => 40404)
          ca4 = FactoryGirl.build(:credit_amount, :plutus_account => contra_asset, :amount => 2)
          ca5 = FactoryGirl.build(:credit_amount, :plutus_account => contra_expense, :amount => 333)

          # debit accounts
          asset = FactoryGirl.create(:asset)
          expense = FactoryGirl.create(:expense)
          contra_liability = FactoryGirl.create(:liability, :contra => true)
          contra_equity = FactoryGirl.create(:equity, :contra => true)
          contra_revenue = FactoryGirl.create(:revenue, :contra => true)
          # debit amounts
          da1 = FactoryGirl.build(:debit_amount, :plutus_account => asset, :amount => 100000)
          da2 = FactoryGirl.build(:debit_amount, :plutus_account => expense, :amount => 1000)
          da3 = FactoryGirl.build(:debit_amount, :plutus_account => contra_liability, :amount => 40404)
          da4 = FactoryGirl.build(:debit_amount, :plutus_account => contra_equity, :amount => 2)
          da5 = FactoryGirl.build(:debit_amount, :plutus_account => contra_revenue, :amount => 333)

          FactoryGirl.create(:transaction, :credit_amounts => [ca1], :debit_amounts => [da1])
          FactoryGirl.create(:transaction, :credit_amounts => [ca2], :debit_amounts => [da2])
          FactoryGirl.create(:transaction, :credit_amounts => [ca3], :debit_amounts => [da3])
          FactoryGirl.create(:transaction, :credit_amounts => [ca4], :debit_amounts => [da4])
          FactoryGirl.create(:transaction, :credit_amounts => [ca5], :debit_amounts => [da5])
        }

        it { should == 0 }
      end
    end
  end
end
