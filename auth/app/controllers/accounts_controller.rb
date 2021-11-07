class AccountsController < ApplicationController
  before_action :set_account, only: %i[show edit update destroy]
  before_action :authenticate_account!, only: :index

  def index
    @accounts = Account.all
  end

  def current
    respond_to do |format|
      format.json { render json: current_account }
    end
  end

  def edit; end

  def update
    respond_to do |format|
      new_role = account_params[:role] unless @account.role == account_params[:role]

      if @account.update(account_params)
        # CUD + BE events
        event_data = {
          public_id: @account.public_id,
          full_name: @account.full_name
        }
        event = ::Event.new(name: 'Account.Updated', data: event_data)
        Producer.produce_sync(payload: event.to_json, topic: 'accounts-stream')

        if new_role
          event_data = { public_id: @account.public_id, role: @account.role }

          event = ::Event.new(name: 'Account.RoleChanged', data: event_data)
          Producer.produce_sync(payload: event.to_json, topic: 'accounts')
        end

        format.html { redirect_to root_path, notice: 'Account was successfully updated.' }
        format.json { render :index, status: :ok, location: @account }
      else
        format.html { render :edit }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @account.update(active: false, disabled_at: Time.now)

    event_data = { public_id: @account.public_id }

    event = ::Event.new(name: 'Account.Deleted', data: event_data)
    Producer.produce_sync(payload: event.to_json, topic: 'accounts-stream')

    respond_to do |format|
      format.html { redirect_to root_path, notice: 'Account was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def current_account
    if doorkeeper_token
      Account.find(doorkeeper_token.resource_owner_id)
    else
      super
    end
  end

  def account_params
    params.require(:account).permit(:email, :role, :full_name, :active)
  end

  def set_account
    @account = Account.find(params[:id])
  end
end
