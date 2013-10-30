json.array!(@process_states) do |process_state|
  json.extract! process_state, :id, :process_name, :process_action, :process_state, :process_info, :process_pid, :simulate_only, :start_time, :end_time, :region
  json.url process_state_url(process_state, format: :json)
end
