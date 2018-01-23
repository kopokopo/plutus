# The Amount class represents debit and credit amounts in the system.
#
# @abstract
#   An amount must be a subclass as either a debit or a credit to be saved to the database.
#
# @author Michael Bulat, modifications: Dennis Ondeng
class Amount < ActiveRecord::Base

  belongs_to :entry, foreign_key: 'transaction_id', class_name: 'Transaction'
  belongs_to :plutus_account

  validates_presence_of :type, :amount, :entry, :plutus_account


  def self.newer_than(query_time)
    where('amounts.created_at >= ?', query_time)
  end

  def self.older_than(query_time)
    where('amounts.created_at <= ?', query_time)
  end

  def self.between_times(from_time, to_time)
    where('amounts.created_at >= ? and amounts.created_at <= ?', from_time, to_time)
  end

  def self.between_times_tail_inclusive(from_time, to_time)
    where('amounts.created_at >= ? and amounts.created_at < ?', from_time, to_time)
  end

  def self.between_times_head_inclusive(from_time, to_time)
    where('amounts.created_at > ? and amounts.created_at <= ?', from_time, to_time)
  end

  def self.in_current_quarter
    current_time = Time.now
    where(:time_period => "#{current_time.year}-#{((current_time.month - 1) / 3) + 1}" )
  end

  def self.in_quarter(quarter)
    where(:time_period => quarter)
  end
end