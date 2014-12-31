require 'yaml'
require 'fileutils'

# build AngularJS (Ng) artifacts


class AngularRailsBuilder < Builder::Base

  @@ng_routes = []
  @@menus = []
  @@ng_modules = []

  # define to 'list' to use the list template, grid to use ngGrid template 
  # or 'table' to use the table template
  LIST_TYPE = 'table'
 
  def build_controller 
    # add this instance as a module

    @@ng_modules << self
  
  end

  def build_route
    # routes are added by the build partials methods

  end


  def build_model
    # nothing to do here - module is already added by build_controller

  end

  def build_list_partial 
    
    return if skip_method(__method__)
    
    template = File.read(template("ng/partial-#{LIST_TYPE}.erb"))
    
    filename = "#{singular_table_name}/list.html"
    
    path = module_path("modules",filename)
    puts "build Ng #{LIST_TYPE} list partial for #{model_name} in #{path}"
    
    text = Erubis::Eruby.new(template).evaluate( self )
    
    # add a route for this partial
    @@ng_routes << {
      :template => '/' + module_path('modules', filename),
      :controller => model_name + 'ListCtrl',
      :url => '/' + namespaced_url(plural_table_name) 
      }
    
 
    # generate the output
    
    write_partial(path,text)

  end

  def build_detail_partial  
    
    return if skip_method(__method__)

    template = File.read(template("ng/partial-detail.erb"))
    
    filename = "#{singular_table_name}/detail.html"
    
    path =  module_path("modules",filename)
    puts "build Ng detail partial for #{model_name} in #{path}"
    
    text = Erubis::Eruby.new(template).evaluate( self )
    
    # add a route for this partial
    @@ng_routes << {
      :template => '/' + module_path('modules', filename),
      :controller => model_name + 'DetailCtrl',
      :url => '/' + namespaced_url(plural_table_name) + '/:' + singular_table_name + 'Id'
      }
      
    # generate the output
    
    write_partial(path,text)

  end
  
  def build_form_partial
    
    return if skip_method(__method__)

    template = File.read(template("ng/partial-form.erb"))
    
    filename = "#{singular_table_name}/form.html"
    
    path =  module_path("modules",filename)
    puts "build Ng form partial for #{model_name} in #{path}"
    
    text = Erubis::Eruby.new(template).evaluate( self )
    
    # add a route for this partial
    @@ng_routes << {
      :template => '/' + module_path('modules', filename),
      :controller => model_name + 'FormCtrl',
      :url => '/' + namespaced_url(plural_table_name) + '/new'
      }
    @@ng_routes << {
      :template => '/' + module_path('modules', filename),
      :controller => model_name + 'FormCtrl',
      :url => '/' + namespaced_url(plural_table_name) + '/:' + singular_table_name + 'Id/edit'
      }
  
      
    # generate the output
    
    write_partial(path,text)
  end

  def build_view 
    return if skip_method(__method__)
     
    build_form_partial
    
    build_detail_partial     
    
    build_list_partial
  end


  def build_unit_test 
    return if skip_method(__method__)
    puts "build unit test for #{model_name} in test/unit"
  end

  def build_e2e_test 
    return if skip_method(__method__)
    puts "build e2e test for #{model_name} in test/e2e"
  end

  def build_test_fixtures 
    return if skip_method(__method__)
    puts "build fixture for #{model_name} in test/fixtures"
  end
  
  def build_test
    return if skip_method(__method__)
    build_test_fixtures
    build_unit_test
    build_e2e_test
  end
  
  def build_menu
    #puts "build Ng menu for #{model_name}"
    @@menus << { :model_name => model_name, :comment => columns['comment'], 
      :url => '/' + namespaced_url(plural_table_name) }
  end
  
  def menus
    @@menus
  end
  
  def models
    @@ng_routes
  end

  def finalize_artifacts
    
    return if skip_method(__method__)
    
    filename = "app.js"
    path = module_path("app",filename)
    puts "finalize Ng app in #{path}"
 
    template = File.read(template("ng/app.js.erb"))
    
    text = Erubis::Eruby.new(template).evaluate( self )

    # write the routes output
    path = module_path("app",filename)
    write_asset(path,text) 
    
    filename = 'services.js'
    path = module_path("app",filename)
    puts "finalize Ng services in #{path}"
    template = File.read(template("ng/services.js.erb"))
    
    text = Erubis::Eruby.new(template).evaluate( self )
   
    # generate the output
    
    write_asset(path,text)
    
    # create the angular modules
    finalize_modules
    
    # create the navigation menu
    finalize_menu
    
    # add the generated javascripts to application.js
    finalize_application
    
    finalize_angular_root_partials
    
  end
  
  def finalize_modules
    
    return if skip_method(__method__)
    
    @@ng_modules.each do |mod|
    
      filename = "#{mod.model_name}Module.js"
      path = module_path("modules",filename)
      puts "build Ng module for #{mod.model_name} in #{path}"
      
      template = File.read(template("ng/module.js.erb"))

      module_text = Erubis::Eruby.new(template).evaluate( mod )

      # generate the output 
     
      write_asset(path,module_text)
    end
    
  end
  
  # build header and footer angular root partials
  def finalize_angular_root_partials
    
    return if skip_method(__method__)
    
    ['header','footer','home'].each do |file|      
      filename = "#{file}.html"
      
      path = module_path("partials",filename)
      puts "build Angular root partial in #{path}"
      
      template = File.read(template("ng/#{file}.html.erb"))
      text = ERB.new(template, nil, '-').result(binding)
      
      write_partial(path,text)  
    end

  end
  
  def finalize_menu
    
    return if skip_method(__method__)
      
    filename = "menu.html"
    path =  module_path("partials",filename)
    puts "finalize Ng menu in #{path}"
    
    template = File.read(template("ng/menu.html.erb"))
    
    text = Erubis::Eruby.new(template).evaluate( self )
    
    # generate the output
    
    write_partial(path,text)
    
  end
  

  # add the generated javascripts to application.js
  def finalize_application
    
    # integrate the angular libs into the application.js in the right order
    filename = "#{destination}/app/assets/javascripts/application.js"
    
    content = File.read(filename)
    
    if namespace
      libs = "//= require #{namespace}/app/app
//= require #{namespace}/app/services
//= require_tree ./#{namespace}/modules"
    else
      libs = "//= require app/app
//= require app/services
//= require_tree ./modules"
    end
    
    unless content.include? libs
      content.sub!(/include builder modules\s*$/) {|matched| matched + "\n#{libs}\n"}
    end

    write_asset("application.js",content) 
  end
  
end
