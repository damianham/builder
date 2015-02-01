require 'yaml'
require 'fileutils'
require 'erubis'
require 'erb'

# build Rails artifacts with validations and relations in the models

class RailsBuilder < Builder::Base
  

  @@rails_routes = []
  @@menus = []
  @@comments = []
  
  # wrap the content in a module
  def write_module_artifact(filename,content = nil)
    if namespace
      content = indent(content).chomp
      content = "module #{namespace.capitalize}\n#{content}\nend\n"
    end
     
    write_artifact(filename,content)
  end
 
  # create a controller for a table 
  def build_controller
    
    return if skip_method(__method__)
    
    filename = plural_table_name + '_controller.rb'
    
    template = File.read(template("rails/controller.erb"))

    text = Erubis::Eruby.new(template).evaluate( self )
    
    path = namespaced_path("app/controllers",filename)
    puts "build Rails controller for #{controller_name} in #{path}"
    write_module_artifact(path,text)

  end

  # build a model for a table 
  def build_model
    
    return if skip_method(__method__)

    filename = singular_table_name + '.rb'
    
    template = File.read(template("rails/model.erb"))
    text = Erubis::Eruby.new(template).evaluate( self )

    path = namespaced_path("app/models",filename)
    puts "build Rails model for #{model_name} in #{path}"
    write_module_artifact(path,text)

  end

  # define some methods required to build the Rails artifacts using the Rails 4 templates
  def uncountable?
    singular_table_name == plural_table_name
  end

  def index_helper
    uncountable? ? "#{plural_table_name}_index" : plural_table_name
  end
  
  def class_name
    model_name
  end
  
  def capture(*args)
    yield(*args)
  end
   
  # Wrap block with namespace of current application
  # if namespace exists 
  def module_namespacing(&block)
    content = capture(&block)
    content = wrap_with_namespace(content) if namespace
  end

  def indent(content, multiplier = 2)
    spaces = " " * multiplier
    content.each_line.map {|line| line.blank? ? line : "#{spaces}#{line}" }.join
  end

  def wrap_with_namespace(content)
    content = indent(content).chomp
    "module #{namespace}\n#{content}\nend\n"
  end


  # build the Rails views for a table
  def build_view 
    
    return if skip_method(__method__)
    
    # build edit _form index new show
  
    ['_form','edit','new','index','show'].each do |file|
      
    
      template = File.read(template("rails/views/#{file}.html.erb"))
      
      # need to use ERB for these templates
      text = ERB.new(template, nil, '-').result(binding)

      filename = "#{file}.html.erb"
      #puts "build Rails view"
      
      path = namespaced_path("app/views","#{plural_table_name}/"+filename)
      puts "build Rails #{file} view for #{model_name} in #{path}"
      write_artifact(path,text)
         
    end
    
    # build the json views
    ['index','show'].each do |file|
    
      template = File.read(template("rails/views/#{file}.json.jbuilder"))
      text = ERB.new(template, nil, '-').result(binding)
    
      filename = "#{file}.json.jbuilder"
      #puts "build Rails JSON view "
      
      path = namespaced_path("app/views","#{plural_table_name}/"+filename)
      puts "build Rails #{file} JSON view for #{model_name} in #{path}"
      write_artifact(path,text)
         
    end
  
  end
  
  # build the unit test for a table
  def build_unit_test 
    
    return if skip_method(__method__)
    
    filename = "#{singular_table_name}_test.rb"
    puts "build Rails unit test for #{model_name} in test/models"
    # build model test
      
    template = File.read(template("rails/test/unit_test.rb"))
    #text = ERB.new(template, nil, '-').result(binding)
    text = Erubis::Eruby.new(template).evaluate( self )

    path = namespaced_path("test/models",filename)
    write_artifact(path,text)
  end
  
  # build the controller test for a table
  def build_functional_test 
    
    return if skip_method(__method__)

    filename = "#{singular_table_name}_controller_test.rb"
    puts "build Rails functional test for #{model_name} in test/controllers"

    template = File.read(template("rails/test/functional_test.rb"))
    #text = ERB.new(template, nil, '-').result(binding)
    text = Erubis::Eruby.new(template).evaluate( self )

    path = namespaced_path("test/controllers",filename)
    write_artifact(path,text) 
  end

  # build the integration test for a table
  def build_integration_test 
    
    return if skip_method(__method__)

    filename = "#{plural_table_name}_test.rb"
    puts "build Rails integration test for #{model_name} in test/integration"

    template = File.read(template("rails/test/integration_test.rb"))
    #text = ERB.new(template, nil, '-').result(binding)
    text = Erubis::Eruby.new(template).evaluate( self )

    path = namespaced_path("test/integration",filename)
    write_artifact(path,text)  
  end

  # build the test fixtures for a table
  def build_test_fixtures 
    
    return if skip_method(__method__)
    
    puts "build Rails fixture for #{model_name} in test/fixtures"
    
    filename = "#{plural_table_name}.yml"
    template = File.read(template("rails/test/fixtures.yml"))
    #text = ERB.new(template, nil, '-').result(binding)
    text = Erubis::Eruby.new(template).evaluate( self )

    path = namespaced_path("test/fixtures",filename)
    write_artifact(path,text)  
  end
  
  # build the test helper for a table
  def build_test_helper 
    
    return if skip_method(__method__)
    
    puts "build Rails test helper for #{model_name} in test/helpers"
    filename = "#{plural_table_name}_helper_test.rb"

    template = File.read(template("rails/test/helper_test.rb"))
    #text = ERB.new(template, nil, '-').result(binding)
    text = Erubis::Eruby.new(template).evaluate( self )

    path = namespaced_path("test/helpers",filename)
    write_artifact(path,text)  
  end
  
  # build the test artifacts
  def build_test
    
    return if skip_method(__method__)
    
    build_test_fixtures
    build_test_helper
    build_functional_test
    build_integration_test
    build_unit_test
  end
  
  # add the table to the menus
  def build_menu
    comment = table_info['comment']
    #puts "build Rails menu for #{model_name} (#{comment}) in app/views/shared"
    @@menus << { :model_name => model_name, :comment => comment, :route => "/"+ plural_table_name}
    
  end

  # add the table to the routes
  def build_route 
    #puts "build Rails route for #{@model_name} in config/routes.rb"
    
    template = File.read(template("rails/route.erb"))
    text = Erubis::Eruby.new(template).evaluate( self )

    @@rails_routes << text
  end
  
  # add the given routes to the Rails config/routes.rb file
  def add_routes(routes)
    
    return if skip_method(__method__)
    
    write_artifact("config/routes.rb") do |file|
      file.puts("Rails.application.routes.draw do")
      file.puts("
  concern :common_routes do
    get :range, on: :collection
    # handles requests where relation is a query param (RestAngularBuilder)
    # e.g.  users/1/related.json?relation=department
    get :related   
    post :search
  end")
      
      if namespace
        file.puts("  namespace :#{namespace} do")
      end
      routes.each do |route|
        namespace.nil? ? file.puts(route) : file.puts(indent(route))
      end
      if namespace
        file.puts("  end")
      end
      file.puts("end")
    end

  end
  
  # finalize the routes and menus
  def finalize_artifacts
    
    return if skip_method(__method__)
    
    puts "finalize Rails routes in config/routes.rb"
    
    add_routes(@@rails_routes)
    
    # create the navigation menu
    finalize_menu
    
  end
  
  def menus
    @@menus
  end
  # build the menu system
  def finalize_menu
    
    return if skip_method(__method__)    
    
    # save the menu items in a partial for inclusion in main menu
    template = File.read(template("rails/menu_container.erb"))

    #text = Erubis::Eruby.new(template).result(:menus => @@menus, :comments => @@comments)
    
    text = Erubis::Eruby.new(template).evaluate( self )
    
    filename = "app/views/shared/_menu.html.erb"
    puts "finalize Rails menu in #{filename}"

    # generate the output
    write_artifact(filename,text)
    
    # create a single page that lists the database tables with their comments
    template = File.read(template("rails/table_index.erb"))

    #text = Erubis::Eruby.new(template).result(:menus => @@menus, :comments => @@comments)
    
    text = Erubis::Eruby.new(template).evaluate( self )
    
    filename = "app/views/shared/_index.html.erb"
    puts "finalize Rails menu index in #{filename}"

    # generate the output
    write_artifact(filename,text)
    
  end
  


end  # end class

