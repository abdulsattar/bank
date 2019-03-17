require "./bank.rb"

describe "Bank" do
  describe "transact" do
    it "should subtract balance when type is debit" do
      account = BankAccount.new(1000)
      account.transact(:debit, 100)
      expect(account.balance).to eq(900)
    end

    it "should add balance when type is credit" do
      account = BankAccount.new(1000)
      account.transact(:credit, 100)
      expect(account.balance).to eq(1100)
    end

    it "should maintain right balance when two transactions happen concurrently" do
      account = BankAccount.new(30_000_000)
      threads = []
      
      2.times do
        threads << Thread.new {
          1_000_000.to_i.times do
            account.transact(:debit, 10)
          end
          }
      end

      threads.each { |thr| thr.join }
      expect(account.balance).to eq(10_000_000)
    end
  end
end