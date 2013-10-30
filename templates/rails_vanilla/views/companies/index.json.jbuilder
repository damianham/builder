json.array!(@companies) do |company|
  json.extract! company, :company_code, :dn, :company_description, :business_category, :updated_at, :updated_by
  json.url company_url(company, format: :json)
end
