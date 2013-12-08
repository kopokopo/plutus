# The Expense class is an account type used to represents assets or services consumed in the generation of revenue.
#
# === Normal Balance
# The normal balance on Expense plutus_accounts is a *Debit*.
#
# @see http://en.wikipedia.org/wiki/Expense Expenses
#
# @author Michael Bulat
class Expense < PlutusAccount

  # The balance of the account.
  #
  # Expenses have normal debit balances, so the credits are subtracted from the debits
  # unless this is a contra account, in which debits are subtracted from credits
  #
  # @example
  #   >> expense.balance
  #   => #<BigDecimal:103259bb8,'0.2E4',4(12)>
  #
  # @return [BigDecimal] The decimal value balance
  def balance
    unless contra
      debits_balance - credits_balance
    else
      credits_balance - debits_balance
    end
  end

  # The balance of the account since a specific date
  def balance_from_date(query_date)
    unless contra
      debits_balance_from_date(query_date) - credits_balance_from_date(query_date)
    else
      credits_balance_from_date(query_date) - debits_balance_from_date(query_date)
    end
  end

  # Get the balances only from the beginning of the current quarter
  # This depends on accounts having been closed out and the balances carried forward
  # At the beginning of the quarter.
  #
  # @example
  #   If today is Nov 20th 2013 and you call
  #   >>expense.balance
  #   The returned balance will be calculated from Oct 1 00:00:00
  #
  # @author Dennis Ondeng
  #
  def current_balance
    unless contra
      current_debits_balance - current_credits_balance
    else
      current_credits_balance - current_debits_balance
    end
  end

  def balance_at_time(query_time)
    unless contra
      debits_balance_at_time(query_time) - credits_balance_at_time(query_time)
    else
      credits_balance_at_time(query_time) - debits_balance_at_time(query_time)
    end
  end

  # This class method is used to return
  # the balance of all Expense accounts.
  #
  # Contra accounts are automatically subtracted from the balance.
  #
  # @example
  #   >> Plutus::Expense.balance
  #   => #<BigDecimal:1030fcc98,'0.82875E5',8(20)>
  #
  # @return [BigDecimal] The decimal value balance
  def self.balance
    accounts_balance = BigDecimal.new('0')
    #accounts = self.find(:all)
    self.find_each do |expense|
      unless expense.contra
        accounts_balance += expense.balance
      else
        accounts_balance -= expense.balance
      end
    end
    accounts_balance
  end
end
