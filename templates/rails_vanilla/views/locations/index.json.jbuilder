json.array!(@locations) do |location|
  json.extract! location, :id, :sitecode, :location, :country, :country_name, :region_name, :updated_at, :updated_by
  json.url location_url(location, format: :json)
end
