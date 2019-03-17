require 'thread'

Transaction = Struct.new(:type, :amount) do
  def net_amount
    if type == :credit
      amount
    else
      -amount
    end
  end
end

class BankAccount
  attr_reader :balance, :transactions
  def initialize(balance)
    @balance = balance
    @transactions = []

    @semaphore = Mutex.new
  end

  def transact(type, amount)
    @semaphore.synchronize {
      transaction = Transaction.new(type, amount)
      @transactions << transaction
      @balance = @balance + transaction.net_amount
    }
  end
end