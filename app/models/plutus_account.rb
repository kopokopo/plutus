# The Account class represents accounts in the system. Each account must be subclassed as one of the following types:
#
#   TYPE        | NORMAL BALANCE    | DESCRIPTION
#   --------------------------------------------------------------------------
#   Asset       | Debit             | Resources owned by the Business Entity
#   Liability   | Credit            | Debts owed to outsiders
#   Equity      | Credit            | Owners rights to the Assets
#   Revenue     | Credit            | Increases in owners equity
#   Expense     | Debit             | Assets or services consumed in the generation of revenue
#
# Each account can also be marked as a "Contra Account". A contra account will have it's
# normal balance swapped. For example, to remove equity, a "Drawing" account may be created
# as a contra equity account as follows:
#
#   Plutus::Equity.create(:name => "Drawing", contra => true)
#
# At all times the balance of all accounts should conform to the "accounting equation"
#   Plutus::Assets = Liabilties + Owner's Equity
#
# Each sublclass account acts as it's own ledger. See the individual subclasses for a
# description.
#
# @abstract
#   An account must be a subclass to be saved to the database. The Account class
#   has a singleton method {trial_balance} to calculate the balance on all Accounts.
#
# @see http://en.wikipedia.org/wiki/Accounting_equation Accounting Equation
# @see http://en.wikipedia.org/wiki/Debits_and_credits Debits, Credits, and Contra Accounts
#
# @author Michael Bulat
class PlutusAccount < ActiveRecord::Base

  has_many :credit_amounts, :extend => AmountsExtension
  has_many :debit_amounts, :extend => AmountsExtension
  has_many :credit_transactions, :through => :credit_amounts, :source => :transaction
  has_many :debit_transactions, :through => :debit_amounts, :source => :transaction
  belongs_to :ownable, polymorphic: true

  validates_presence_of :type, :name
  validates_uniqueness_of :name

  # The credit balance for the account.
  #
  # @example
  #   >> asset.credits_balance
  #   => #<BigDecimal:103259bb8,'0.1E4',4(12)>
  #
  # @return [BigDecimal] The decimal value credit balance
  def credits_balance
    credit_amounts.balance
  end

  # The credit balance for the account but since a specified time stamp
  def credits_balance_from_date(query_date)
    credit_amounts.balance_from_date(query_date)
  end

  def credits_balance_at_time(query_time)
    credit_amounts.balance_at_time(query_time)
  end

  def debits_balance_at_time(query_time)
    debit_amounts.balance_at_time(query_time)
  end

  def credits_balance_at_time_no_carry(query_time)
    credit_amounts.balance_at_time_no_carry(query_time)
  end

  def debits_balance_at_time_no_carry(query_time)
    debit_amounts.balance_at_time_no_carry(query_time)
  end

  def current_credits_balance
    credit_amounts.current_balance
  end

  def credits_balance_between_times(from_time, to_time)
    credit_amounts.amount_between_times(from_time, to_time)
  end

  def debits_balance_between_times(from_time, to_time)
    debit_amounts.amount_between_times(from_time, to_time)
  end


  def credits_balance_between_times_tail_inclusive(from_time, to_time)
    credit_amounts.amount_between_times_tail_inclusive(from_time, to_time)
  end

  def credits_balance_between_times_head_inclusive(from_time, to_time)
    credit_amounts.amount_between_times_head_inclusive(from_time, to_time)
  end

  def debits_balance_between_times_head_inclusive(from_time, to_time)
    debit_amounts.amount_between_times_head_inclusive(from_time, to_time)
  end

  def debits_balance_between_times_tail_inclusive(from_time, to_time)
    debit_amounts.amount_between_times_tail_inclusive(from_time, to_time)
  end


  # The debit balance for the account.
  #
  # @example
  #   >> asset.debits_balance
  #   => #<BigDecimal:103259bb8,'0.3E4',4(12)>
  #
  # @return [BigDecimal] The decimal value credit balance
  def debits_balance
    debit_amounts.balance
  end

  #The debit balance for the account but from a specified timestamp
  def debits_balance_from_date(query_date)
    debit_amounts.balance_from_date(query_date)
  end

  def current_debits_balance
    debit_amounts.current_balance
  end

  # The trial balance of all accounts in the system. This should always equal zero,
  # otherwise there is an error in the system.
  #
  # @example
  #   >> Account.trial_balance.to_i
  #   => 0
  #
  # @return [BigDecimal] The decimal value balance of all accounts
  def self.trial_balance
    unless self.new.class == PlutusAccount
      raise(NoMethodError, "undefined method 'trial_balance'")
    else
      Asset.balance - (Liability.balance + Equity.balance + Revenue.balance - Expense.balance)
    end
  end
end
