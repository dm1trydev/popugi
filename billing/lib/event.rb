class Event
  def initialize(name:, data:, version: 1)
    @id = SecureRandom.uuid
    @name = name
    @service = 'billing_service'
    @data = data
    @version = version
    @time = Time.now
  end

  def to_h
    {
      event_id: id,
      event_version: version,
      event_time: time,
      producer: service,
      event_name: name,
      data: data
    }
  end

  def to_json(options = {})
    to_h.to_json(options)
  end

  private

  attr_reader :id, :name, :service, :data, :version, :time
end
