class BalancesController < ApplicationController
  def show
    @balance = Balance.preload(:account, transactions: :task).find(params[:id])
  end
end
