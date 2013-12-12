# Transactions are the recording of debits and credits to various plutus_accounts.
# This table can be thought of as a traditional accounting Journal. 
#
# Posting to a Ledger can be considered to happen automatically, since 
# Accounts have the reverse 'has_many' relationship to either it's credit or
# debit transactions 
#
# @example
#   cash = Asset.find_by_name('Cash')
#   accounts_receivable = Asset.find_by_name('Accounts Receivable')
#
#   Transaction.create(:description => "Receiving payment on an invoice" , 
#                      :debit_account => cash, 
#                      :credit_account => accounts_receivable, 
#                      :amount => 1000)
#
# @see http://en.wikipedia.org/wiki/Journal_entry Journal Entry
# 
# @author Michael Bulat
class Transaction < ActiveRecord::Base
  attr_accessible :description, :commercial_document

  belongs_to :commercial_document, :polymorphic => true
  has_many :credit_amounts, :extend => AmountsExtension
  has_many :debit_amounts, :extend => AmountsExtension
  has_many :credit_accounts, :through => :credit_amounts, :source => :plutus_account
  has_many :debit_accounts, :through => :debit_amounts, :source => :plutus_account

  validates_presence_of :description
  validate :has_credit_amounts?
  validate :has_debit_amounts?
  validate :amounts_cancel?


  # Simple API for building a transaction and associated debit and credit amounts
  #
  # @example
  #   transaction = Plutus::Transaction.build(
  #     description: "Sold some widgets",
  #     debits: [
  #       {account: "Accounts Receivable", amount: 50}],
  #     credits: [
  #       {account: "Sales Revenue", amount: 45},
  #       {account: "Sales Tax Payable", amount: 5}])
  #
  # @return [Plutus::Transaction] A Transaction with built credit and debit objects ready for saving
  def self.build(hash)
    current_time = Time.now
    #if a time period designation is not sent in, default to the current quarter
    current_quarter = hash[:time_period].nil? ? "#{current_time.year}-#{((current_time.month - 1) / 3) + 1}" : hash[:time_period]

    transaction = Transaction.new(:description => hash[:description], :commercial_document => hash[:commercial_document])
    hash[:debits].each do |debit|
      if debit[:amount] > 0 || hash[:allow_zero]
        a = PlutusAccount.find_by_name(debit[:plutus_account])
        transaction.debit_amounts << DebitAmount.new(:plutus_account => a, :amount => debit[:amount], :transaction => transaction, :time_period => current_quarter)
      end
    end
    hash[:credits].each do |credit|
      if credit[:amount] > 0 || hash[:allow_zero]
        a = PlutusAccount.find_by_name(credit[:plutus_account])
        transaction.credit_amounts << CreditAmount.new(:plutus_account => a, :amount => credit[:amount], :transaction => transaction, :time_period => current_quarter)
      end
    end
    transaction
  end



  private
  def has_credit_amounts?
    errors[:base] << "Transaction must have at least one credit amount" if self.credit_amounts.blank?
  end

  def has_debit_amounts?
    errors[:base] << "Transaction must have at least one debit amount" if self.debit_amounts.blank?
  end

  def amounts_cancel?
    errors[:base] << "The credit and debit amounts are not equal" if credit_amounts.balance != debit_amounts.balance
  end
end
