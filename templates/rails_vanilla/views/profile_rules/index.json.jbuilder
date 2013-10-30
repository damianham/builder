json.array!(@profile_rules) do |profile_rule|
  json.extract! profile_rule, :id, :sitecode, :profile, :active, :activation_date, :comments, :updated_at, :updated_by
  json.url profile_rule_url(profile_rule, format: :json)
end
