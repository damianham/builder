json.array!(@policy_rules) do |policy_rule|
  json.extract! policy_rule, :id, :country, :company, :sitecode, :department, :user_type, :policy_id, :is_default, :active, :activation_date, :comments, :updated_at, :updated_by
  json.url policy_rule_url(policy_rule, format: :json)
end
