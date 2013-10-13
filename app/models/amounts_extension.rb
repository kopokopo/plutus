# Association extension for has_many :amounts relations. Internal.
module AmountsExtension
  # Returns a sum of the referenced Amount objects.
  def balance
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

  # Returns a sum of the referenced objects, but only since a specific date
  def balance_from_date(query_date)
    balance = BigDecimal.new('0')
    newer_than(query_date).each do |amount_record|
      if amount_record.amount
        balance += amount_record.amount
      else
        balance = nil
      end
    end
    return balance
  end
end