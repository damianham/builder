require 'yaml'
require 'fileutils'
require 'erubis'
require 'erb'

# build Rails artifacts with validations and relations in the models

class RailsBuilder < Builder::Base
  

  @@rails_routes = []
  @@menus = []
  @@comments = []
  
  def namespace
    # define the namespace here or nil
    nil
  end
 
  # create a controller for a table in app/controllers
  def build_controller
    filename = plural_table_name + '_controller.rb'
    puts "build Rails controller for #{controller_name} in app/controllers"

    template = File.read(template("rails/controller.erb"))

    text = Erubis::Eruby.new(template).result(:model_name => model_name,
    :singular_table_name => singular_table_name,
    :plural_table_name => plural_table_name,
    :controller_name => controller_name,
    :model_symbol => ':' + singular_table_name,
    :schema => schema)
    
    write_artifact("app/controllers",filename,text)

  end

  # build a model for a table in app/models
  def build_model

    filename = singular_table_name + '.rb'

    puts "build Rails model for #{model_name} in app/models"

    template = File.read(template("rails/model.erb"))
    text = Erubis::Eruby.new(template).result(:model_name => model_name, :schema => schema)

    write_artifact("app/models",filename,text)

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
    puts "build Rails views for #{model_name} in app/views"
  # build edit _form index new show
  
    ['_form','edit','new','index','show'].each do |file|
      
    
      template = File.read(template("rails/views/#{file}.html.erb"))
      text = ERB.new(template, nil, '-').result(binding)
    
      filename = "#{file}.html.erb"
      puts "build Rails view in app/views/#{plural_table_name}/#{filename}"
      
      write_artifact("app/views/#{plural_table_name}",filename,text)
         
    end
    
    # build the json views
    ['index','show'].each do |file|
    
      template = File.read(template("rails/views/#{file}.json.jbuilder"))
      text = ERB.new(template, nil, '-').result(binding)
    
      filename = "#{file}.json.jbuilder"
      puts "build Rails view in app/views/#{plural_table_name}/#{filename}"
      
      write_artifact("app/views/#{plural_table_name}",filename,text)
         
    end
  
  end
  
  # build the unit test for a table
  def build_unit_test 
    filename = "#{singular_table_name}_test.rb"
    puts "build Rails unit test for #{model_name} in test/models"
  # build model test
      
    template = File.read(template("rails/test/unit_test.rb"))
    text = ERB.new(template, nil, '-').result(binding)

    write_artifact("test/models",filename,text)
  end
  
  # build the controller test for a table
  def build_functional_test 

    filename = "#{singular_table_name}_controller_test.rb"
    puts "build Rails functional test for #{model_name} in test/controllers"

    template = File.read(template("rails/test/functional_test.rb"))
    text = ERB.new(template, nil, '-').result(binding)

    write_artifact("test/controllers",filename,text)
  end

  # build the integration test for a table
  def build_integration_test 

    filename = "#{plural_table_name}_test.rb"
    puts "build Rails integration test for #{model_name} in test/integration"

    template = File.read(template("rails/test/integration_test.rb"))
    text = ERB.new(template, nil, '-').result(binding)

    write_artifact("test/integration",filename,text)
  end

  # build the test fixtures for a table
  def build_test_fixtures 
    puts "build Rails fixture for #{model_name} in test/fixtures"
    
    filename = "#{plural_table_name}.yml"
    template = File.read(template("rails/test/fixtures.yml"))
    text = ERB.new(template, nil, '-').result(binding)

    write_artifact("test/fixtures",filename,text)
  end
  
  # build the test helper for a table
  def build_test_helper 
    puts "build Rails test helper for #{model_name} in test/helpers"
    filename = "#{plural_table_name}_helper_test.rb"

    template = File.read(template("rails/test/helper_test.rb"))
    text = ERB.new(template, nil, '-').result(binding)

    write_artifact("test/helpers",filename,text)
  end
  
  # build the test artifacts
  def build_test
    build_test_fixtures
    build_test_helper
    build_functional_test
    build_integration_test
    build_unit_test
  end
  
  # add the table to the menus
  def build_menu
    comment = schema['comment']
    #puts "build Rails menu for #{model_name} (#{comment}) in app/views/shared"
    @@menus << { :model_name => model_name, :comment => comment, :route => "/"+ plural_table_name}
    
    @@comments << { :model_name => model_name, :comment => comment, :route => "/"+ plural_table_name}
  end

  # add the table to the routes
  def build_route 
    #puts "build Rails route for #{@model_name} in config/routes.rb"

    # add resources :model_name
    @@rails_routes << "resources :"+ plural_table_name
  end
  
  # add the given routes to the Rails config/routes.rb file
  def add_routes(routes)
    filename = "#{destination}/config/routes.rb"
    
    content = File.read(filename)

    routes.each do |route|
      unless content.include? route
        content.sub!(/\.routes\.draw do\s*$/) {|matched| matched + "\n  #{route}"}
      end
    end
    
    write_artifact("config","routes.rb",content)
  end
  
  # finalize the routes and menus
  def finalize_artifacts
    puts "finalize Rails routes in config/routes.rb"
    
    add_routes(@@rails_routes)
    
    # create the navigation menu
    finalize_menu
    
    # create the angular rails artifacts as the web root
    finalize_angular_root
    
  end
  
  # build the menu system
  def finalize_menu
    
    # save the menu items in a partial for inclusion in main menu
    template = File.read(template("rails/menu_container.erb"))

    text = Erubis::Eruby.new(template).result(:menus => @@menus, :comments => @@comments)
    
    filename = "_menu.html.erb"
    puts "finalize Rails menu in app/views/shared/#{filename}"

    # generate the output
    write_artifact("app/views/shared",filename,text)
    
    # create a single page that lists the database tables with their comments
    template = File.read(template("rails/table_index.erb"))

    text = Erubis::Eruby.new(template).result(:menus => @@menus, :comments => @@comments)
    
    filename = "_index.html.erb"
    puts "finalize Rails menu index in app/views/shared/#{filename}"

    # generate the output
    write_artifact("app/views/shared",filename,text)
    
  end
  
  # build the artifacts to hook AngularJS into the rails app
  def finalize_angular_root
    finalize_angular_root_controller
    finalize_angular_root_view
    finalize_angular_root_route
    finalize_angular_root_partials
  end
  
  # buils the angular root controller
  def finalize_angular_root_controller
    filename = 'angular_controller.rb'
    puts "build Rails root controller in app/controllers"

    template = File.read(template("rails/angular/angular_controller.erb"))

    text = Erubis::Eruby.new(template).result(:model_name => model_name,
    :singular_table_name => singular_table_name,
    :plural_table_name => plural_table_name,
    :controller_name => controller_name,
    :model_symbol => ':' + singular_table_name,
    :schema => schema)
    
    write_artifact("app/controllers",filename,text)
  end
  
  # build the angular root view
  def finalize_angular_root_view
    filename = 'angular.html.erb'
    puts "build Rails root view in app/views"

    template = File.read(template("rails/angular/angular_root_view.erb"))

    text = Erubis::Eruby.new(template).result(:model_name => model_name,
    :singular_table_name => singular_table_name,
    :plural_table_name => plural_table_name,
    :controller_name => controller_name,
    :model_symbol => ':' + singular_table_name,
    :schema => schema)
    
    write_artifact("app/views/angular",filename,text)
  end
  
  # add the root routes to config/routes.rb
  def finalize_angular_root_route
    filename = "#{destination}/config/routes.rb"
    puts "add root route"
        
    content = File.read(filename)
    
    routes = ["get 'angular/fetch_current_user' => 'angular#fetch_current_user'",
      "get 'angular/angular' => 'angular#angular'", 
      "root :to => 'angular#angular'"]
    
    add_routes(routes)
  end
  
  # build header and footer angular root partials
  def finalize_angular_root_partials
    ['header','footer'].each do |file|
      template = File.read(template("rails/angular/#{file}.html.erb"))
      text = ERB.new(template, nil, '-').result(binding)
    
      filename = "#{file}.html.erb"
      puts "build Angular partial in app/assets/javascripts/partials/#{filename}"
      
      write_artifact("app/assets/javascripts/partials",filename,text)
    end

  end


end  # end class

