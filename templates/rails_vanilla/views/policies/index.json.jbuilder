json.array!(@policies) do |policy|
  json.extract! policy, :id, :friendly_name, :policy_type, :is_default, :dn, :policy_xml, :tombstoned, :updated_at, :updated_by
  json.url policy_url(policy, format: :json)
end
