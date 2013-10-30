json.array!(@sweepers) do |sweeper|
  json.extract! sweeper, :id, :object_class, :object_id, :object_name, :dn, :treebase, :rfc2254_filter, :action_type, :action_date, :comments, :updated_at, :updated_by
  json.url sweeper_url(sweeper, format: :json)
end
