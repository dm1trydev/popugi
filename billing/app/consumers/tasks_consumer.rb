class TasksConsumer < ApplicationConsumer
  def consume
    params_batch.each do |message|
      payload = message.payload

      case [payload['event_name'], payload['event_version']]
      when ['Task.Assigned', 1] # because we already have old events
        validation = SchemaRegistry.validate_event(payload, 'task.assigned', version: payload['event_version'])
        next unless validation.success?

        bird_caught(payload)
      when ['Task.BirdCaught', 1]
        validation = SchemaRegistry.validate_event(payload, 'task.bird_caught', version: payload['event_version'])
        next unless validation.success?

        bird_caught(payload)
      when ['Task.Closed', 1] # because we already have old events
        validation = SchemaRegistry.validate_event(payload, 'task.closed', version: payload['event_version'])
        next unless validation.success?

        millet_poured(payload)
      when ['Task.MilletPoured', 1]
        validation = SchemaRegistry.validate_event(payload, 'task.millet_poured', version: payload['event_version'])
        next unless validation.success?

        millet_poured(payload)
      end
    end
  end

  private

  def bird_caught(payload)
    ApplicationRecord.transaction do
      task = Task.find_by_public_id!(payload['data']['public_id'])
      account = Account.find_by_public_id!(payload['data']['performer_public_id'])
      catch_bird(task, account)
      decrease_account_balance(task, account)
    end
  end

  def millet_poured(payload)
    ApplicationRecord.transaction do
      task = Task.find_by_public_id!(payload['data']['public_id'])
      account = Account.find_by_public_id!(payload['data']['performer_public_id'])
      pour_millet(task)
      increase_account_balance(task, account)
    end
  end

  def decrease_account_balance(task, account)
    change_balance(task.id, account, task.fee, 'withdrawal')
  end

  def increase_account_balance(task, account)
    change_balance(task.id, account, task.amount, 'accrual')
  end

  def change_balance(task_id, account, amount, type)
    transaction =
      account
        .balance
        .transactions
        .create!(task_id: task_id, amount: amount, kind: type, balance_cycle_id: BalanceCycle.current_cycle.id)

    event_data = {
      public_id: transaction.reload.public_id,
      amount: amount,
      type: type,
      owner_public_id: account.public_Id
    }
    event = Event.new(name: 'Transaction.Completed', data: event_data)
    validation = SchemaRegistry.validate_event(event.to_h.as_json, 'transaction.completed', version: 1)
    WaterDrop::SyncProducer.call(event.to_json, topic: 'transactions') if validation.success?

    case type
    when 'accrual'
      account.balance.amount += amount
    when 'withdrawal'
      account.balance.amount -= amount
    else
      raise StandardError, 'Unknown transaction type!'
    end
    account.balance.save!
  end

  def catch_bird(task, account)
    task.account_id = account.id
    task.status = 'bird_in_a_cage'
    task.save!
  end

  def pour_millet(task)
    task.status = 'millet_in_a_bowl'
    task.save!
  end
end
