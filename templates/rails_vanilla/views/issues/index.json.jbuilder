json.array!(@issues) do |issue|
  json.extract! issue, :id, :object_id, :object_name, :object_class, :issue_type, :comments, :updated_at, :updated_by
  json.url issue_url(issue, format: :json)
end
