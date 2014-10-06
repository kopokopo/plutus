# Association extension for has_many :amounts relations. Internal.
module AmountsExtension
  # Returns a sum of the referenced Amount objects.
  def balance
    balance = BigDecimal.new('0')
    balance += sum(:amount)
    return balance
  end

  def old_balance
    balance = BigDecimal.new('0')
    each do |amount_record|
      if amount_record.amount
        balance += amount_record.amount
      else
        balance = nil
      end
    end
    return balance
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
    balance = BigDecimal.new('0')
    balance += in_current_quarter.sum(:amount)
    return balance
  end

  # Returns a sum of the referenced objects, but only since a specific date
  def balance_from_date(query_date)
    balance = BigDecimal.new('0')
    return balance if query_date.nil?
    balance += newer_than(query_date).sum(:amount)
    return balance
  end

  # Returns the balance as it is/was at a specific point in time.
  def balance_at_time(query_time)
    balance = BigDecimal.new('0')
    return balance if query_time.nil?
    quarter = "#{query_time.year}-#{((query_time.month - 1) / 3) + 1}"
    balance += in_quarter(quarter).older_than(query_time).sum(:amount)
    return balance
  end

  # Returns the balance as it is/was at a specific point in time.
  # But does take into consideration time periods
  def balance_at_time_no_carry(query_time)
    balance = BigDecimal('0')
    return balance if query_time.nil?
    balance += older_than(query_time).sum(:amount)
    return balance
  end

  def amount_between_times(from_time, to_time)
    balance = BigDecimal('0')
    return balance if (from_time.nil? || to_time.nil?)
    balance += between_times(from_time, to_time).sum(:amount)
    return balance
  end
end