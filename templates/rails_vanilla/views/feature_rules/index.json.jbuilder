json.array!(@feature_rules) do |feature_rule|
  json.extract! feature_rule, :id, :feature, :feature_id, :country, :sitecode, :company, :department, :user_type, :deny, :active, :activation_date, :comments, :updated_at, :updated_by
  json.url feature_rule_url(feature_rule, format: :json)
end
