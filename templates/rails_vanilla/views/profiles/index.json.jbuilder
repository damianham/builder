json.array!(@profiles) do |profile|
  json.extract! profile, :id, :dn, :name, :description, :tombstoned, :updated_at, :updated_by
  json.url profile_url(profile, format: :json)
end
