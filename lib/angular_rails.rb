require 'yaml'
require 'fileutils'

# build AngularJS (Ng) artifacts


class AngularRailsBuilder < Builder::Base
  
  def setup
    @@ng_routes = []
    @@menus = []
    @@ng_modules = []
  end
  
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

  def build_table_partial prefix
    return if skip_method(__method__)
    
    template_path = template("ng/#{prefix}-table.erb")
    
    return unless File.exist?(template_path)
    
    template = File.read(template_path)
    
    filename = "#{singular_table_name}/#{prefix}_table.html"
    
    path = module_path("views",filename)
    puts "build Ng #{prefix} table partial for #{model_name} in #{path}"
    
    text = Erubis::Eruby.new(template).evaluate( self )
  
    # generate the output
    
    write_view(path,text)
    
  end
  
  def build_grid_partial prefix
    return if skip_method(__method__)
    
    template_path = template("ng/#{prefix}-grid.erb")
    
    return unless File.exist?(template_path)
    
    template = File.read(template_path)
    
    filename = "#{singular_table_name}/#{prefix}_grid.html"
    
    path = module_path("views",filename)
    puts "build Ng #{prefix} grid partial for #{model_name} in #{path}"
    
    text = Erubis::Eruby.new(template).evaluate( self )
  
    # generate the output
    
    write_view(path,text)
  end
  
  def build_list_partial prefix
    return if skip_method(__method__)
    
    template_path = template("ng/#{prefix}-list.erb")
    
    return unless File.exist?(template_path)
    
    template = File.read(template_path)
    
    filename = "#{singular_table_name}/#{prefix}_list.html"
    
    path = module_path("views",filename)
    puts "build Ng #{prefix} list partial for #{model_name} in #{path}"
    
    text = Erubis::Eruby.new(template).evaluate( self )
    
    # generate the output
    
    write_view(path,text)

  end

  def build_detail_partial prefix, controller
    
    return if skip_method(__method__)

    template_path = template("ng/#{prefix}-detail.erb")
    
    return unless File.exist?(template_path)
    
    template = File.read(template_path)
    
    filename = "#{singular_table_name}/#{prefix}_detail.html"
    
    path =  module_path("views",filename)
    puts "build Ng #{prefix} detail partial for #{model_name} in #{path}"
    
    text = Erubis::Eruby.new(template).evaluate( self )
    
    # add a route for this partial
    @@ng_routes << {
      :name => "#{plural_table_name}.detail",
      :template => '/' + module_path('views', filename),
      :controller => model_name + controller,
      :url => '/' + namespaced_url(plural_table_name) + '/:' + singular_table_name + 'Id'
    }
      
    # generate the output
    
    write_view(path,text)

  end
  
  def build_form_partial prefix, controller
    
    return if skip_method(__method__)

    template_path = template("ng/#{prefix}-form.erb")
    
    return unless File.exist?(template_path)
    
    template = File.read(template_path)
    
    filename = "#{singular_table_name}/#{prefix}_form.html"
    
    path =  module_path("views",filename)
    puts "build Ng #{prefix} form partial for #{model_name} in #{path}"
    
    text = Erubis::Eruby.new(template).evaluate( self )
    
    # add a route for this partial
    @@ng_routes << {
      :name => "#{plural_table_name}.new",
      :template => '/' + module_path('views', filename),
      :controller => model_name + controller,
      :url => '/' + namespaced_url(plural_table_name) + '/new'
    }
    @@ng_routes << {
      :name => "#{plural_table_name}.edit",
      :template => '/' + module_path('views', filename),
      :controller => model_name + controller,
      :url => '/' + namespaced_url(plural_table_name) + '/:' + singular_table_name + 'Id/edit'
    }
  
      
    # generate the output
    
    write_view(path,text)
  end
  
  def build_list_route prefix, controller
    
    filename = "#{singular_table_name}/#{prefix}_#{list_type}.html"
    
    # add a route for the list 
    @@ng_routes << {
      :name => "#{plural_table_name}.list",
      :template => '/' + module_path('views', filename),
      :controller => model_name + controller,
      :url => '/' + namespaced_url(plural_table_name) 
    }
  end

  def build_view 
    return if skip_method(__method__)
     
    build_form_partial 'partial', 'FormCtrl'
    
    build_detail_partial 'partial', 'DetailCtrl'     
    
    build_list_partial 'partial'
    
    build_table_partial 'partial'
    
    build_grid_partial 'partial'
    
    build_list_route 'partial', 'ListCtrl'
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
    @@menus << { :model_name => model_name, :comment => table_info['comment'], 
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
        
    # create the angular modules
    finalize_modules
    
    # create the navigation menu
    finalize_menu
    
    # create the services module
    finalize_services
    
    # create the controllers module
    finalize_controllers
    
    # create the main app 
    finalize_angular_app
    
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
      
      write_view(path,text)  
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
    write_view(path,text)
    
  end
  
  def finalize_services
    return if skip_method(__method__)
    
    filename = 'services.js'    
    path = module_path("app",filename)
    puts "finalize Ng services in #{path}"
    template = File.read(template("ng/services.js.erb"))
    
    text = Erubis::Eruby.new(template).evaluate( self )
   
    # generate the output     
    write_asset(path,text)
    
  end
  
  def finalize_controllers
    return if skip_method(__method__)
    
    filename = 'controllers.js'    
    path = module_path("app",filename)
    puts "finalize Ng services in #{path}"
    template = File.read(template("ng/controllers.js.erb"))
    
    text = Erubis::Eruby.new(template).evaluate( self )
   
    # generate the output     
    write_asset(path,text)
    
  end

  def finalize_angular_app
    return if skip_method(__method__)
    
    filename = (appname || namespace || "app") + ".js"
    path = module_path("app",filename)
    puts "finalize Ng app in #{path}"
 
    template = File.read(template("ng/app.js.erb"))
    
    text = Erubis::Eruby.new(template).evaluate( self )

    # write the routes output
    write_asset(path,text) 
    
  end
  
  # add the generated javascripts to application.js
  def finalize_application
    
    return if skip_method(__method__)

    # integrate the angular libs into the application.js in the right order
    filename = "application.js"
    
    puts "finalize rails application.js"
 
    template = File.read(template("ng/application.js.erb"))
    
    text = Erubis::Eruby.new(template).evaluate( self )
  
    write_asset(filename,text) 
  end
  
end
