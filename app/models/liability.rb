# The Liability class is an account type used to represents debts owed to outsiders.
#
# === Normal Balance
# The normal balance on Liability plutus_accounts is a *Credit*.
#
# @see http://en.wikipedia.org/wiki/Liability_(financial_accounting) Liability
#
# @author Michael Bulat
class Liability < PlutusAccount

  # The balance of the account.
  #
  # Liability accounts have normal credit balances, so the debits are subtracted from the credits
  # unless this is a contra account, in which credits are subtracted from debits
  #
  # @example
  #   >> liability.balance
  #   => #<BigDecimal:103259bb8,'0.2E4',4(12)>
  #
  # @return [BigDecimal] The decimal value balance
  def balance
    unless contra
      credits_balance - debits_balance
    else
      debits_balance - credits_balance
    end
  end

  # The balance of the account since a specific date
  # @author Dennis Ondeng
  def balance_from_date(query_date)
    unless contra
      credits_balance_from_date(query_date) - debits_balance_from_date(query_date)
    else
      debits_balance_from_date(query_date) - credits_balance_from_date(query_date)
    end
  end

  # Get the balances only from the beginning of the current quarter
  # This depends on accounts having been closed out and the balances carried forward
  # At the beginning of the quarter.
  #
  # @example
  #   If today is Nov 20th 2013 and you call
  #   >>liability.balance
  #   The returned balance will be calculated from Oct 1 00:00:00
  #
  # @author Dennis Ondeng
  #
  def current_balance
    unless contra
      current_credits_balance - current_debits_balance
    else
      current_debits_balance - current_credits_balance
    end
  end


  def balance_at_time(query_time)
    unless contra
      credits_balance_at_time(query_time) - debits_balance_at_time(query_time)
    else
      debits_balance_at_time(query_time) - credits_balance_at_time(query_time)
    end
  end

  def balance_at_time_no_carry(query_time)
    unless contra
      credits_balance_at_time_no_carry(query_time) - debits_balance_at_time_no_carry(query_time)
    else
      debits_balance_at_time_no_carry(query_time) - credits_balance_at_time_no_carry(query_time)
    end
  end

  def amount_bewtween_times(from_time, to_time)
    unless contra
      credits_balance_between_times(from_time, to_time) - debits_balance_between_times(from_time, to_time)
    else
      debits_balance_between_times(from_time, to_time) - credits_balance_between_times(from_time, to_time)
    end
  end

  # Balance of all Liability accounts
  #
  # @example
  #   >> Plutus::Liability.balance
  #   => #<BigDecimal:1030fcc98,'0.82875E5',8(20)>
  def self.balance
    accounts_balance = BigDecimal.new('0')
    #accounts = self.find(:all)
    self.find_each do |liability|
      unless liability.contra
        accounts_balance += liability.balance
      else
        accounts_balance -= liability.balance
      end
    end
    accounts_balance
  end


  def self.balance_by_account_type(account_type)
    bal = BigDecimal('0')
    result = self.find_by_sql(
        " SELECT
          (SUM(CASE WHEN amts.type = 'CreditAmount' THEN amts.amount ELSE 0 END)
          - SUM(CASE WHEN amts.type = 'DebitAmount' THEN amts.amount ELSE 0 END)) total_balance
        FROM amounts amts INNER JOIN plutus_accounts pa ON pa.id = amts.plutus_account_id
        WHERE pa.plutus_account_type = '#{account_type}'")
    result.first.try(:total_balance)
    bal = BigDecimal(result.first.try(:total_balance)) if result.first.try(:total_balance)
    bal
  end

  def self.balance_at_time_by_account_type(account_type, query_time)
    bal = BigDecimal('0')
    result = self.find_by_sql(
        " SELECT
          (SUM(CASE WHEN amts.type = 'CreditAmount' THEN amts.amount ELSE 0 END)
          - SUM(CASE WHEN amts.type = 'DebitAmount' THEN amts.amount ELSE 0 END)) total_balance
        FROM amounts amts INNER JOIN plutus_accounts pa ON pa.id = amts.plutus_account_id
        WHERE pa.plutus_account_type = '#{account_type}'
          AND amts.created_at < '#{query_time.strftime('%Y-%m-%d %H:%M:%S.%6N')}' ")
    result.first.try(:total_balance)
    bal = BigDecimal(result.first.try(:total_balance)) if result.first.try(:total_balance)
    bal
  end


  def self.amount_between_times_by_account_type(account_type, from_time, to_time)
    bal = BigDecimal('0')
    result = self.find_by_sql(
        " SELECT
          (SUM(CASE WHEN amts.type = 'CreditAmount' THEN amts.amount ELSE 0 END)
          - SUM(CASE WHEN amts.type = 'DebitAmount' THEN amts.amount ELSE 0 END)) total_balance
        FROM amounts amts INNER JOIN plutus_accounts pa ON pa.id = amts.plutus_account_id
        WHERE pa.plutus_account_type = '#{account_type}'
          AND amts.created_at >= '#{from_time.strftime('%Y-%m-%d %H:%M:%S.%6N')}'
          AND amts.created_at < '#{to_time.strftime('%Y-%m-%d %H:%M:%S.%6N')}' ")
    result.first.try(:total_balance)
    bal = BigDecimal(result.first.try(:total_balance)) if result.first.try(:total_balance)
    bal
  end
end
