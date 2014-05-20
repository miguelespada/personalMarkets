class AccountingDomain

  Accounting = Struct.new(:earnings, :paybacks)
  
  def self.for_user user_id
    accounting = Accounting.new earnings(user_id), paybacks(user_id)
    def accounting.owed
      (self.earnings - self.paybacks).round(2)
    end
    accounting
  end

  def self.pay user_id, amount
    user = User.find user_id
    Payback.create( user: user, amount: amount)
  end

private

  def self.earnings user_id
    earnings = Earning.for_user user_id
    amounts = earnings.map {|earning| earning.amount}
    amounts.reduce(:+)
  end    

  def self.paybacks user_id
    paybacks = Payback.for_user user_id
    amounts = paybacks.map {|payback| payback.amount}
    amounts.reduce(:+)
  end

end