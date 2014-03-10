require 'spec_helper'

=begin
describe Transaction do

  it "should create a transaction" do
    transaction = Factory(:transaction)
  end
  
  it "should not be valid without a credit account" do
    transaction = Factory.build(:transaction, :credit_account => nil)
    transaction.should_not be_valid
  end
  
  it "should not be valid without a valid credit account" do
    bad_account = Factory.build(:asset, :name => nil)
    transaction = Factory.build(:transaction, :credit_account => bad_account)
    transaction.should_not be_valid
  end  

  it "should not be valid without a debit account" do
    transaction = Factory.build(:transaction, :debit_account => nil)
    transaction.should_not be_valid
  end
  
  it "should not be valid without a valid credit account" do
    bad_account = Factory.build(:asset, :name => nil)
    transaction = Factory.build(:transaction, :debit_account => bad_account)
    transaction.should_not be_valid
  end  
  
  it "should not be valid without an amount" do
    transaction = Factory.build(:transaction, :amount => nil)
    transaction.should_not be_valid
  end

  it "should not be valid without a description" do
    transaction = Factory.build(:transaction, :description => nil)
    transaction.should_not be_valid
  end
  
  it "should have a polymorphic commercial document associations" do
    mock_document = Factory(:transaction) # one would never do this, but it allows us to not require a migration for the test
    transaction = Factory(:transaction, :commercial_document => mock_document)
    saved_transaction = Transaction.find(transaction.id)
    saved_transaction.commercial_document.should == mock_document
  end

end

=end

module Plutus
  describe Transaction do
    let(:transaction) { FactoryGirl.build(:transaction) }
    subject { transaction }

    it { should_not be_valid }

    context "with credit and debit" do
      let(:transaction) { FactoryGirl.build(:transaction_with_credit_and_debit) }
      it { should be_valid }

      it "should require a description" do
        transaction.description = nil
        transaction.should_not be_valid
      end
    end

    context "with a debit" do
      before {
        transaction.debit_amounts << FactoryGirl.build(:debit_amount, transaction: transaction)
      }
      it { should_not be_valid }

      context "with an invalid credit" do
        before {
          transaction.credit_amounts << FactoryGirl.build(:credit_amount, transaction: transaction, amount: nil)
        }
        it { should_not be_valid }
      end
    end

    context "with a credit" do
      before {
        transaction.credit_amounts << FactoryGirl.build(:credit_amount, transaction: transaction)
      }
      it { should_not be_valid }

      context "with an invalid debit" do
        before {
          transaction.debit_amounts << FactoryGirl.build(:debit_amount, transaction: transaction, amount: nil)
        }
        it { should_not be_valid }
      end
    end

    it "should require the debit and credit amounts to cancel" do
      transaction = FactoryGirl.build(:transaction)
      #amt1 = FactoryGirl.build(:credit_amount, :amount => 100, :transaction => transaction)
      transaction.credit_amounts << FactoryGirl.build(:credit_amount, :amount => 300, :transaction => transaction)
      puts "Transaction credits: #{transaction.credit_amounts}"
      transaction.debit_amounts << FactoryGirl.build(:debit_amount, :amount => 200, :transaction => transaction)
      puts "Credits balance: #{transaction.credit_amounts.balance} Old balance #{transaction.credit_amounts.old_balance}"
      puts "Debits balance: #{transaction.debit_amounts.balance}"
      transaction.should_not be_valid
      transaction.errors['base'].should == ["The credit and debit amounts are not equal"]
    end

    it "should require the debit and credit amounts to cancel even with fractions" do
      transaction = FactoryGirl.build(:transaction)
      transaction.credit_amounts << FactoryGirl.build(:credit_amount, :amount => 100.1, :transaction => transaction)
      transaction.debit_amounts << FactoryGirl.build(:debit_amount, :amount => 100.2, :transaction => transaction)
      transaction.should_not be_valid
      transaction.errors['base'].should == ["The credit and debit amounts are not equal"]
    end

    it "should have a polymorphic commercial document associations" do
      mock_document = FactoryGirl.create(:asset) # one would never do this, but it allows us to not require a migration for the test
      transaction = FactoryGirl.build(:transaction_with_credit_and_debit, commercial_document: mock_document)
      transaction.save!
      saved_transaction = Transaction.find(transaction.id)
      saved_transaction.commercial_document.should == mock_document
    end

    it "should allow building a transaction and credit and debits with a hash" do
      FactoryGirl.create(:asset, name: "Accounts Receivable")
      FactoryGirl.create(:revenue, name: "Sales Revenue")
      FactoryGirl.create(:liability, name: "Sales Tax Payable")
      mock_document = FactoryGirl.create(:asset)
      transaction = Transaction.build(
        description: "Sold some widgets",
        commercial_document: mock_document,
        debits: [
          {account: "Accounts Receivable", amount: 50}],
        credits: [
          {account: "Sales Revenue", amount: 45},
          {account: "Sales Tax Payable", amount: 5}])
      transaction.save!

      saved_transaction = Transaction.find(transaction.id)
      saved_transaction.commercial_document.should == mock_document
    end

  end
end


