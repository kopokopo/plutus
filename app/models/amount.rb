require 'strong_parameters'
# The Amount class represents debit and credit amounts in the system.
#
# @abstract
#   An amount must be a subclass as either a debit or a credit to be saved to the database.
#
# @author Michael Bulat
class Amount < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
  #attr_accessible :plutus_account, :amount, :transaction, :time_period

  belongs_to :transaction
  belongs_to :plutus_account

  validates_presence_of :type, :amount, :transaction, :plutus_account

  #validates_presence_of :type, :message => "Amount type is needed"
  #validates_presence_of :amount, :message => "amount is needed"
  #validates_presence_of :transaction, :message => "transaction is needed"
  #validates_presence_of :plutus_account, :message => "plutus account is needed"


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



  #def self.in_current_quarter
  #  current_time = Time.now
  #  where(:time_period => "#{current_time.year}-#{((current_time.month - 1) / 3) + 1}" )
  #end


  #Hack!! because carry_forward did not work
  def self.in_current_quarter
    where(time_period: ['2016-1','2016-2'])
  end

  #Hack!! because carry_forward did not work
  #def self.in_quarter(quarter)
  #  where(:time_period => quarter)
  #end

  def self.in_quarter(quarter)
    if quarter == '2016-2'
      where(time_period: ['2016-1','2016-2'])
    else
      where(:time_period => quarter)
    end
  end

end