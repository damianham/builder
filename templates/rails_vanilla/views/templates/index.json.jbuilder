json.array!(@templates) do |template|
  json.extract! template, :id, :name, :language, :subject, :body_content, :comment, :updated_at, :updated_by
  json.url template_url(template, format: :json)
end
