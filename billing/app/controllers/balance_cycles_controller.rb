class BalanceCyclesController < ApplicationController
  def close
    CloseBalanceCycleAndOpenNewService.call

    redirect_to root_path
  end
end
