<%- columns = attributes.collect { |attribute| ':' + attribute.name  }.join(', ') -%>
json.extract! @<%= singular_table_name %>, :id, <%= columns %> 
