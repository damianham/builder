require 'test_helper'

<% module_namespacing do -%>
class <%= class_name %>ControllerTest < ActionController::TestCase
  setup do
    @<%= singular_table_name %> = <%= plural_table_name %>(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:<%= plural_table_name %>)
  end

  test "should get new" do
    get :new
    assert_response :success
  end
<%
  attributes = columns.reject{|key| key == 'id'}.keys.collect {|column_name| 
    "#{column_name}: @#{singular_table_name}.#{column_name}" }.join(', ')
%>
  test "should create <%= singular_table_name %>" do
    assert_difference('<%= class_name %>.count') do
      post :create, <%= singular_table_name %>: {  <%= attributes %>    }
    end

    assert_redirected_to <%= singular_table_name %>_path(assigns(:<%= singular_table_name %>))
  end

  test "should show <%= singular_table_name %>" do
    get :show, id: @<%= singular_table_name %>
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @<%= singular_table_name %>
    assert_response :success
  end

  test "should update <%= singular_table_name %>" do
    patch :update, id: @<%= singular_table_name %>, <%= singular_table_name %>: { <%= attributes %> }
  
    assert_redirected_to <%= singular_table_name %>_path(assigns(:<%= singular_table_name %>))
  end

  test "should destroy <%= singular_table_name %>" do
    assert_difference('<%= class_name %>.count', -1) do
      delete :destroy, id: @<%= singular_table_name %>
    end

    assert_redirected_to <%= plural_table_name %>_path
  end
end
<% end -%>
