class CloseBalanceCycleAndOpenNewService
  class << self
    def call
      BalanceCycle.transaction do
        close if BalanceCycle.current_cycle

        open
      end

      nil
    end

    private

    def close
      BalanceCycle.transaction do
        Balance.preload(:account, :transactions).where('amount > 0').each do |balance|
          transaction =
            balance
              .transactions
              .create!(amount: balance.amount, kind: 'withdrawal', balance_cycle_id: BalanceCycle.current_cycle.id)
          ProcessTransactionService.new(transaction, 'salary').call
          puts "Notification about salary sent to #{balance.account.email}"
        end

        BalanceCycle.current_cycle.closed_at = Time.current
        BalanceCycle.current_cycle.state = :closed
        BalanceCycle.current_cycle.save!
      end
    end

    def open
      BalanceCycle.current = BalanceCycle.create!
    end
  end
end
