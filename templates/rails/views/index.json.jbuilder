<%- columns = attributes.collect { |attribute| ':' + attribute.name  }.join(', ') -%>
json.array!(@<%= singular_table_name %>) do |<%= singular_table_name %>|
  json.extract! <%= singular_table_name %>, <%= columns %> 
  json.url <%= singular_table_name %>_url(<%= singular_table_name %>, format: :json)
end