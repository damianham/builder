json.array!(@attribute_rules) do |attribute_rule|
  json.extract! attribute_rule, :id, :country, :sitecode, :company, :department, :user_type, :attribute, :attribute_value, :member_of, :operation, :update_attribute, :new_value, :feature, :group, :active, :activation_date, :comments, :updated_at, :updated_by
  json.url attribute_rule_url(attribute_rule, format: :json)
end
