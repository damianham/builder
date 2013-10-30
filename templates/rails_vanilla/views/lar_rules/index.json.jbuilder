json.array!(@lar_rules) do |lar_rule|
  json.extract! lar_rule, :id, :feature, :feature_id, :country, :sitecode, :company, :allow, :active, :activation_date, :comments, :updated_at, :updated_by
  json.url lar_rule_url(lar_rule, format: :json)
end
