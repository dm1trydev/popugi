class AccountsBalancesController < ApplicationController
  before_action :authenticate!
  before_action :authorize!
  helper_method :calculate_balance_for_current_cycle

  def index
    @accounts = Account.preload(balance: :transactions)

  end

  private

  def calculate_balance_for_current_cycle(account)
    account
      .balance
      .transactions
      .select { |transaction| transaction.balance_cycle_id == BalanceCycle.current_cycle.id }
      .sum { |transaction| transaction.withdrawal? ? -transaction.amount : transaction.amount }
  end

  def authorize!
    return if current_account.admin? || current_account.accountant?

    redirect_to root_path, alert: 'Not authorized'
  end
end

