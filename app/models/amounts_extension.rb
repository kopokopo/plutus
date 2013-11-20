# Association extension for has_many :amounts relations. Internal.
module AmountsExtension
  # Returns a sum of the referenced Amount objects.
  def balance
    balance = BigDecimal.new('0')
    find_each do |amount_record|
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
    in_current_quarter.find_each do |amount_record|
      if amount_record.amount
        balance += amount_record.amount
      else
        balance = nil
      end
    end
    return balance
  end

  # Returns a sum of the referenced objects, but only since a specific date
  def balance_from_date(query_date)
    balance = BigDecimal.new('0')
    newer_than(query_date).find_each do |amount_record|
      if amount_record.amount
        balance += amount_record.amount
      else
        balance = nil
      end
    end
    return balance
  end
end