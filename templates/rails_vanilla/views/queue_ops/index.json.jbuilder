json.array!(@queue_ops) do |queue_op|
  json.extract! queue_op, :country, :sitecode, :company, :feature, :user_id, :qid, :operation, :new_value, :old_value, :event_id, :old_num, :new_num, :comment, :on_hold, :rule_table, :rule_id, :rule_source, :transaction_id, :priority, :simulate_only, :domain_name, :dn
  json.url queue_op_url(queue_op, format: :json)
end
