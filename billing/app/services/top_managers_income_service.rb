class TopManagersIncomeService
  def self.calculate(balance_cycle = BalanceCycle.current_cycle)
    closed = balance_cycle.transactions.accrual.sum(&:amount)
    open = balance_cycle.transactions.withdrawal.sum(&:amount)

    (closed - open) * -1
  end
end

