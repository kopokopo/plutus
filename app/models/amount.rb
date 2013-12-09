# The Amount class represents debit and credit amounts in the system.
#
# @abstract
#   An amount must be a subclass as either a debit or a credit to be saved to the database.
#
# @author Michael Bulat
class Amount < ActiveRecord::Base
  attr_accessible :plutus_account, :amount, :transaction, :time_period

  belongs_to :transaction
  belongs_to :plutus_account

  validates_presence_of :type, :amount, :transaction, :plutus_account

  scope :newer_than, lambda {|query_date|
    where("created_at > '#{query_date.strftime('%Y-%m-%d %H:%M:%S.%6N')}'")
  }


  def self.older_than(query_time)
    where("created_at < '#{query_time.strftime('%Y-%m-%d %H:%M:%S.%6N')}'")
  end

  def self.in_current_quarter
    current_time = Time.now
    where(:time_period => "#{current_time.year}-#{((current_time.month - 1) / 3) + 1}" )
  end

  def self.in_quarter(quarter)
    where(:time_period => quarter)
  end

end