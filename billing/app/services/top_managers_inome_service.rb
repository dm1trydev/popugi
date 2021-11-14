class TopManagersIncomeService
  def self.calculate(balance_cycle = BalanceCycle.current_cycle)
    closed = Task.where(balance_cycle_id: balance_cycle.id, status: 'closed').sum(&:amount)
    open = Task.where(balance_cycle_id: balance_cycle.id, status: 'open').sum(&:fee)

    (closed + open) * -1
  end
end

