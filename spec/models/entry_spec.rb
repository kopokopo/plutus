require 'spec_helper'

module Plutus
  describe Entry do
    let(:entry) { FactoryBot.build(:entry) }

    it "is invalid" do
      expect(entry).to be_invalid
    end

    context "with credit and debit" do
      let(:entry) { FactoryBot.build(:entry_with_credit_and_debit) }
      it "is valid" do
        expect(entry).to be_valid
      end

      it "should require a description" do
        entry.description = nil
        expect(entry).to be_invalid
      end
    end

    context "with a debit" do
      before {
        entry.debit_amounts << FactoryBot.build(:debit_amount, entry: entry)
      }
      it { is_expected.to be_invalid }

      context "with an invalid credit" do
        before {
          entry.credit_amounts << FactoryBot.build(:credit_amount, entry: entry, amount: nil)
        }
        it { is_expected.to be_invalid }
      end
    end

    context "with a credit" do
      before {
        entry.credit_amounts << FactoryBot.build(:credit_amount, entry: entry)
      }
      it { is_expected.to be_invalid }

      context "with an invalid debit" do
        before {
          entry.debit_amounts << FactoryBot.build(:debit_amount, entry: entry, amount: nil)
        }
        it { is_expected.to be_invalid }
      end
    end

    it "should require the debit and credit amounts to cancel" do
      entry.credit_amounts << FactoryBot.build(:credit_amount, :amount => 100, :entry => entry)
      entry.debit_amounts << FactoryBot.build(:debit_amount, :amount => 200, :entry => entry)
      aggregate_failures do
        expect(entry).to be_invalid
        expect(entry.errors['base']).to eq(["The credit and debit amounts are not equal"])
      end
    end

    it "should require the debit and credit amounts to cancel even with fractions" do
      entry = FactoryBot.build(:entry)
      entry.credit_amounts << FactoryBot.build(:credit_amount, :amount => 100.1, :entry => entry)
      entry.debit_amounts << FactoryBot.build(:debit_amount, :amount => 100.2, :entry => entry)
      aggregate_failures do
        expect(entry).to be_invalid
        expect(entry.errors['base']).to eq(["The credit and debit amounts are not equal"])
      end
    end

    it "should have a polymorphic commercial document associations" do
      mock_document = FactoryBot.create(:asset) # one would never do this, but it allows us to not require a migration for the test
      entry = FactoryBot.build(:entry_with_credit_and_debit, commercial_document: mock_document)
      entry.save!
      saved_entry = Entry.find(entry.id)
      expect(saved_entry.commercial_document).to eq(mock_document)
    end

    it "should allow building an entry and credit and debits with a hash" do
      FactoryBot.create(:asset, name: "Accounts Receivable")
      FactoryBot.create(:revenue, name: "Sales Revenue")
      FactoryBot.create(:liability, name: "Sales Tax Payable")
      mock_document = FactoryBot.create(:asset)
      entry = Entry.build(
        description: "Sold some widgets",
        commercial_document: mock_document,
        debits: [
          { account: "Accounts Receivable", amount: 50 }],
        credits: [
          { account: "Sales Revenue", amount: 45 },
          { account: "Sales Tax Payable", amount: 5 }])
      entry.save!

      saved_entry = Entry.find(entry.id)
      expect(saved_entry.commercial_document).to eq(mock_document)
    end

  end
end
