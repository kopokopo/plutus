require 'spec_helper'

module Plutus
  describe Account do
    let(:account) { FactoryBot.build(:account) }

    it "is invalid" do
      expect(account).to be_invalid
    end

    describe "when using a child type" do
      let(:account) { FactoryBot.create(:account, type: "Finance::Asset") }
      it "is valid" do
        expect(account).to be_valid
      end

      it "should be unique per name" do
        conflict = FactoryBot.build(:account, name: account.name, type: account.type)
        aggregate_failures do
          expect(conflict).to be_invalid
          expect(conflict.errors[:name]).to eq(["has already been taken"])
        end
      end
    end

    it "does not respond to :balance" do
      expect(account).to_not respond_to(:balance)
    end

    describe ".trial_balance" do
      let(:trial_balance) { Account.trial_balance }

      it "should be a kind of BigDecimal" do
        expect(trial_balance).to be_kind_of(BigDecimal)
      end

      context "when given no entries" do
        it "should equal 0" do
          expect(trial_balance).to eq(0)
        end
      end

      context "when given correct entries" do
        before(:each) do
          # credit accounts
          liability = FactoryBot.create(:liability)
          equity = FactoryBot.create(:equity)
          revenue = FactoryBot.create(:revenue)
          contra_asset = FactoryBot.create(:asset, :contra => true)
          contra_expense = FactoryBot.create(:expense, :contra => true)
          # credit amounts
          ca1 = FactoryBot.build(:credit_amount, :account => liability, :amount => 100000)
          ca2 = FactoryBot.build(:credit_amount, :account => equity, :amount => 1000)
          ca3 = FactoryBot.build(:credit_amount, :account => revenue, :amount => 40404)
          ca4 = FactoryBot.build(:credit_amount, :account => contra_asset, :amount => 2)
          ca5 = FactoryBot.build(:credit_amount, :account => contra_expense, :amount => 333)

          # debit accounts
          asset = FactoryBot.create(:asset)
          expense = FactoryBot.create(:expense)
          contra_liability = FactoryBot.create(:liability, :contra => true)
          contra_equity = FactoryBot.create(:equity, :contra => true)
          contra_revenue = FactoryBot.create(:revenue, :contra => true)
          # debit amounts
          da1 = FactoryBot.build(:debit_amount, :account => asset, :amount => 100000)
          da2 = FactoryBot.build(:debit_amount, :account => expense, :amount => 1000)
          da3 = FactoryBot.build(:debit_amount, :account => contra_liability, :amount => 40404)
          da4 = FactoryBot.build(:debit_amount, :account => contra_equity, :amount => 2)
          da5 = FactoryBot.build(:debit_amount, :account => contra_revenue, :amount => 333)

          FactoryBot.create(:entry, :credit_amounts => [ca1], :debit_amounts => [da1])
          FactoryBot.create(:entry, :credit_amounts => [ca2], :debit_amounts => [da2])
          FactoryBot.create(:entry, :credit_amounts => [ca3], :debit_amounts => [da3])
          FactoryBot.create(:entry, :credit_amounts => [ca4], :debit_amounts => [da4])
          FactoryBot.create(:entry, :credit_amounts => [ca5], :debit_amounts => [da5])
        end

        it "should equal 0" do
          expect(trial_balance).to eq(0)
        end
      end
    end
  end
end
