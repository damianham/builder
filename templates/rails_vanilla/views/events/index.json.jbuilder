json.array!(@events) do |event|
  json.extract! event, :id, :description, :updated_at, :updated_by
  json.url event_url(event, format: :json)
end
