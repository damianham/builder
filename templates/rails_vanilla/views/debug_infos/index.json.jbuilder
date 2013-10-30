json.array!(@debug_infos) do |debug_info|
  json.extract! debug_info, :id, :name, :user_id, :transaction_id, :debug_data, :updated_at, :updated_by
  json.url debug_info_url(debug_info, format: :json)
end
