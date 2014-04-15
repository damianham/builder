<%- columns = attributes.collect { |attribute| ':' + attribute.name  }.join(', ') -%>
json.array!(@<%= plural_table_name %>) do |<%= singular_table_name %>|
  json.extract! <%= singular_table_name %>, :id, <%= columns %> 
  json.url <%= namespace.nil? ? "" : namespace + '_' %><%= singular_table_name %>_url(<%= singular_table_name %>, format: :json)
end
