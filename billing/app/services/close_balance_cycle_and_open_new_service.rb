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
      BalanceCycle.current_cycle.closed_at = Time.current
      BalanceCycle.current_cycle.state = :closed
      BalanceCycle.current_cycle.save!

      Balance.where('amount > 0').update_all(amount: 0)
    end

    def open
      BalanceCycle.current = BalanceCycle.create!
    end
  end
end
