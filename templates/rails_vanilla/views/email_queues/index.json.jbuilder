json.array!(@email_queues) do |email_queue|
  json.extract! email_queue, :id, :event_id, :user_id, :transaction_id, :queue_id, :old_moc_number, :new_moc_number, :change_date, :revoke_date, :headers, :sent_at, :updated_at, :updated_by
  json.url email_queue_url(email_queue, format: :json)
end
