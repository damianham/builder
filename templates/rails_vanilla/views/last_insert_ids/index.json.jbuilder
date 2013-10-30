json.array!(@last_insert_ids) do |last_insert_id|
  json.extract! last_insert_id, :name, :value
  json.url last_insert_id_url(last_insert_id, format: :json)
end
