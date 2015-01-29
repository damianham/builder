require 'yaml'
require 'fileutils'
require 'erubis'
require 'erb'

# build RSpec TDD artifacts

class RSpecBuilder < Builder::Base
  
  def build_controller 
    return if skip_method(__method__)

    filename = "#{plural_table_name}_controller_spec.rb"
    puts "build RSpec controller test for #{model_name} in spec/controllers"

    template = File.read(template(File.join("spec","controller_spec.erb")))
    #text = ERB.new(template, nil, '-').result(binding)
    text = Erubis::Eruby.new(template).evaluate( self )

    path = namespaced_path(File.join("spec","generated", "controllers"),filename)
    write_artifact(path,text) 
  end
    
  def build_model
    return if skip_method(__method__)

    filename = "#{singular_table_name}_spec.rb"
    puts "build RSpec model test for #{model_name} in spec/models"

    template = File.read(template(File.join("spec","model_spec.erb")))
    #text = ERB.new(template, nil, '-').result(binding)
    text = Erubis::Eruby.new(template).evaluate( self )

    path = namespaced_path(File.join("spec","generated","models"),filename)
    write_artifact(path,text)
    
  end
    
  def build_view
    return if skip_method(__method__)
    
    build_edit
    build_index
    build_new
    build_show
  end
  
  def build_edit
    return if skip_method(__method__)
    
    filename = File.join("#{plural_table_name}", "edit.html.erb_spec.rb")
    puts "build RSpec edit view test for #{model_name} in spec/views/#{plural_table_name}"

    template = File.read(template(File.join("spec","views","edit_spec.erb")))
    #text = ERB.new(template, nil, '-').result(binding)
    text = Erubis::Eruby.new(template).evaluate( self )

    path = namespaced_path(File.join("spec","generated","views"),filename)
    write_artifact(path,text)
  end
  
  def build_index
    return if skip_method(__method__)
    
    filename = File.join("#{plural_table_name}", "index.html.erb_spec.rb")
    puts "build RSpec index view test for #{model_name} in spec/views/#{plural_table_name}"

    template = File.read(template(File.join("spec","views","index_spec.erb")))
    #text = ERB.new(template, nil, '-').result(binding)
    text = Erubis::Eruby.new(template).evaluate( self )

    path = namespaced_path(File.join("spec","generated","views"),filename)
    write_artifact(path,text)
  end
  
  def build_new
    return if skip_method(__method__)
    
    filename = File.join("#{plural_table_name}", "new.html.erb_spec.rb")
    puts "build RSpec new view test for #{model_name} in spec/views/#{plural_table_name}"

    template = File.read(template(File.join("spec","views","new_spec.erb")))
    #text = ERB.new(template, nil, '-').result(binding)
    text = Erubis::Eruby.new(template).evaluate( self )

    path = namespaced_path(File.join("spec","generated","views"),filename)
    write_artifact(path,text)
  end
  
  def build_show
    return if skip_method(__method__)
    
    filename = File.join("#{plural_table_name}", "show.html.erb_spec.rb")
    puts "build RSpec show view test for #{model_name} in spec/views/#{plural_table_name}"

    template = File.read(template(File.join("spec","views","show_spec.erb")))
    #text = ERB.new(template, nil, '-').result(binding)
    text = Erubis::Eruby.new(template).evaluate( self )

    path = namespaced_path(File.join("spec","generated","views"),filename)
    write_artifact(path,text)
  end
    
  # build the test artifacts
  def build_test
    return if skip_method(__method__)
    
    build_test_fixtures
    build_test_helper
    build_test_request

  end
  
  # build the test fixtures for a table
  def build_test_fixtures 
    return if skip_method(__method__)
    
    puts "build RSpec fixture for #{model_name} in spec/fixtures"
    
    filename = "#{plural_table_name}.yml"
    template = File.read(template(File.join("spec", "fixtures.yml.erb")))
    #text = ERB.new(template, nil, '-').result(binding)
    text = Erubis::Eruby.new(template).evaluate( self )

    path = namespaced_path(File.join("spec","generated","fixtures"),filename)
    write_artifact(path,text)  
  end
  
  # build the test helper for a table
  def build_test_helper 
    return if skip_method(__method__)
    
    puts "build RSpec helper test for #{model_name} in spec/helpers"
    filename = "#{plural_table_name}_helper_spec.rb"

    template = File.read(template(File.join("spec", "helper_spec.erb")))
    #text = ERB.new(template, nil, '-').result(binding)
    text = Erubis::Eruby.new(template).evaluate( self )

    path = namespaced_path(File.join("spec","generated","helpers"),filename)
    write_artifact(path,text)  
  end
  
  def build_test_request
    return if skip_method(__method__)
    
    puts "build RSpec request test for #{model_name} in spec/requests"
    filename = "#{plural_table_name}_spec.rb"

    template = File.read(template(File.join("spec", "request_spec.erb")))
    #text = ERB.new(template, nil, '-').result(binding)
    text = Erubis::Eruby.new(template).evaluate( self )

    path = namespaced_path(File.join("spec","generated","requests"),filename)
    write_artifact(path,text)
  end
  
  def build_route
    return if skip_method(__method__)

    filename = "#{plural_table_name}_routing_spec.rb"
    puts "build RSpec routing test for #{model_name} in spec/routing"

    template = File.read(template(File.join("spec","routing_spec.erb")))
    #text = ERB.new(template, nil, '-').result(binding)
    text = Erubis::Eruby.new(template).evaluate( self )

    path = namespaced_path(File.join("spec","generated","routing"),filename)
    write_artifact(path,text)
  end
    
  def finalize_artifacts
    return if skip_method(__method__)
  end

  

end
