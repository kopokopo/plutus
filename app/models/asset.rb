# The Asset class is an account type used to represents resources owned by the business entity. 
#
# === Normal Balance
# The normal balance on Asset plutus_accounts is a *Debit*.
#
# @see http://en.wikipedia.org/wiki/Asset Assets
#
# @author Michael Bulat
class Asset < PlutusAccount

  scope :of_plutus_account_type, lambda {|account_type|
    where(:plutus_account_type => account_type)
  }


  # The balance of the account.
  #
  # Assets have normal debit balances, so the credits are subtracted from the debits
  # unless this is a contra account, in which debits are subtracted from credits
  #
  # @example
  #   >> asset.balance
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

  #The balance of the account since a specific date
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
  #   >>asset.balance
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

  def balance_at_time_no_carry(query_time)
    unless contra
      debits_balance_at_time_no_carry(query_time) - credits_balance_at_time_no_carry(query_time)
    else
      credits_balance_at_time_no_carry(query_time) - debits_balance_at_time_no_carry(query_time)
    end
  end


  # This class method is used to return
  # the balance of all Asset accounts.
  #
  # Contra accounts are automatically subtracted from the balance.
  #
  # @example
  #   >> Plutus::Asset.balance
  #   => #<BigDecimal:1030fcc98,'0.82875E5',8(20)>
  #
  # @return [BigDecimal] The decimal value balance
  def self.balance
    accounts_balance = BigDecimal.new('0')
    #accounts = self.find(:all)
    self.find_each do |asset|
      unless asset.contra
        accounts_balance += asset.balance
      else
        accounts_balance -= asset.balance
      end
    end
    accounts_balance
  end

  def self.balance_by_account_type(account_type)
    accounts_balance = BigDecimal('0')
    self.of_plutus_account_type(account_type).find_each do |asset|
      unless asset.contra
        accounts_balance += asset.balance
      else
        accounts_balance -= asset.balance
      end
    end
    accounts_balance
  end


  def self.balance_by_account_type(account_type)
    result = self.find_by_sql(
        " SELECT
          (SUM(CASE WHEN amts.type = 'DebitAmount' THEN amts.amount ELSE 0 END)
          - SUM(CASE WHEN amts.type = 'CreditAmount' THEN amts.amount ELSE 0 END)) balance
        FROM amounts amts INNER JOIN plutus_accounts pa ON pa.id = amts.plutus_account_id
        WHERE pa.plutus_account_type = '#{account_type}'")
    result.first.balance
  end

  def self.balance_at_time_by_account_type(account_type, query_time)
    result = self.find_by_sql(
        " SELECT
          (SUM(CASE WHEN amts.type = 'DebitAmount' THEN amts.amount ELSE 0 END)
          - SUM(CASE WHEN amts.type = 'CreditAmount' THEN amts.amount ELSE 0 END)) balance
        FROM amounts amts INNER JOIN plutus_accounts pa ON pa.id = amts.plutus_account_id
        WHERE pa.plutus_account_type = '#{account_type}'
          AND amts.created_at < '#{query_time.strftime('%Y-%m-%d %H:%M:%S.%6N')}' ")
    result.first.balance
  end


end