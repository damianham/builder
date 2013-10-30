json.array!(@template_rules) do |template_rule|
  json.extract! template_rule, :id, :company, :country, :sitecode, :event_id, :template_id, :comment, :updated_at, :updated_by
  json.url template_rule_url(template_rule, format: :json)
end
