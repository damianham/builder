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
    
    text = Erubis::Eruby.new(template).evaluate( self )
    
    # add a route for this partial
    @@ng_routes << {
      :template => '/assets/' + module_path('modules', filename),
      :controller => model_name + 'ListCtrl',
      :url => '/' + namespaced_url(plural_table_name) 
      }
    
 
    # generate the output
    path = module_path("modules",filename)
    puts "build Ng #{LIST_TYPE} list partial for #{model_name} in #{path}"

    write_artifact(path,text)

  end

  def build_detail_partial  
    
    return if skip_method(__method__)

    template = File.read(template("ng/partial-detail.erb"))
    
    filename = "#{singular_table_name}/detail.html"
    
    text = Erubis::Eruby.new(template).evaluate( self )
    
    # add a route for this partial
    @@ng_routes << {
      :template => '/assets/' + module_path('modules', filename),
      :controller => model_name + 'DetailCtrl',
      :url => '/' + namespaced_url(plural_table_name) + '/:' + singular_table_name + 'Id'
      }
      
    # generate the output
    path = module_path("modules",filename)
    puts "build Ng detail partial for #{model_name} in #{path}"
    write_artifact(path,text)

  end
  
  def build_form_partial
    
    return if skip_method(__method__)

    template = File.read(template("ng/partial-form.erb"))
    
    filename = "#{singular_table_name}/form.html"
    
    text = Erubis::Eruby.new(template).evaluate( self )
    
    # add a route for this partial
    @@ng_routes << {
      :template => '/assets/' + module_path('modules', filename),
      :controller => model_name + 'FormCtrl',
      :url => '/' + namespaced_url(plural_table_name) + '/new'
      }
    @@ng_routes << {
      :template => '/assets/' + module_path('modules', filename),
      :controller => model_name + 'FormCtrl',
      :url => '/' + namespaced_url(plural_table_name) + '/:' + singular_table_name + 'Id/edit'
      }
  
      
    # generate the output
    path = module_path("modules",filename)
    puts "build Ng form partial for #{model_name} in #{path}"
    write_artifact(path,text)
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
    @@menus << { :model_name => model_name, :comment => schema['comment'], 
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
 
    template = File.read(template("ng/app.js.erb"))

    #text = Erubis::Eruby.new(template).result( :models => @@ng_routes, :namespace => namespace)
    
    text = Erubis::Eruby.new(template).evaluate( self )

    # write the routes output
    path = module_path("app",filename)
    write_artifact(path,text) 
    
    # create the angular modules
    finalize_modules
    
    # create the navigation menu
    finalize_menu
    
    # copy the angular library into the application
    finalize_angular_lib
    
    # integrate the angular stylesheets
    finalize_angular_stylesheets
    
    finalize_angular_root_partials
    
  end
  
  def finalize_modules
    
    return if skip_method(__method__)
    
    @@ng_modules.each do |mod|
    
      filename = "#{mod.singular_table_name}/#{mod.model_name}Module.js"
      template = File.read(template("ng/module.js.erb"))

      module_text = Erubis::Eruby.new(template).evaluate( mod )

      # generate the output 
      path = module_path("modules",filename)
      puts "build Ng module for #{mod.model_name} in #{path}"
      write_artifact(path,module_text)
    end
    
  end
  
  # build header and footer angular root partials
  def finalize_angular_root_partials
    
    return if skip_method(__method__)
    
    ['header','footer','home'].each do |file|
      template = File.read(template("ng/#{file}.html.erb"))
      text = ERB.new(template, nil, '-').result(binding)
    
      filename = "#{file}.html"
      
      path = module_path("partials",filename)
      puts "build Angular root partial in #{path}"
      write_artifact(path,text)  
    end

  end
  
  def finalize_menu
    
    return if skip_method(__method__)
      
    filename = "menu.html"
    template = File.read(template("ng/menu.html.erb"))
    
    text = Erubis::Eruby.new(template).evaluate( self )
    
    # generate the output
    path = module_path("partials",filename)
    puts "finalize Ng menu in #{path}"
    write_artifact(path,text)
    
    filename = 'services.js'
    # build the angular header
    template = File.read(template("ng/services.js.erb"))
    
    text = Erubis::Eruby.new(template).evaluate( self )
   
    # generate the output
    path = module_path("app",filename)
    puts "finalize Ng services in #{path}"
    write_artifact(path,text)
    
  end
  
  def copy_angular_lib
    return if skip_method(__method__)
    
    src = template("ng/lib")

    puts "copying recursively #{src} to #{destination}"
    FileUtils.cp_r src, destination
    
  end
  # copy the angular library to the destination
  def finalize_angular_lib
    
    copy_angular_lib
    
    # integrate the angular libs into the application.js in the right order
    filename = "#{destination}/application.js"
    
    content = File.read(filename)
    
    libs = "//= require lib/angular/angular.min
//= require lib/angular/angular-resource.min
//= require lib/angular/angular-route.min
//= require lib/angular/angular-cookies.min
//= require lib/angular/angular-sanitize.min
//= require lib/angular/angular-touch.min
//= require lib/angular/angular-animate.min
//= require lib/bootstrap.min
//= require lib/ng-table.min
// now include application modules
"

    # add the angular libs and boot strap first
    unless content.include? libs
      content.sub!(/require turbolinks\s*$/) {|matched| matched + "\n#{libs}\n"}
    end
    
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
      content.sub!(/now include application modules\s*$/) {|matched| matched + "\n#{libs}\n"}
    end

    write_artifact("application.js",content) 
  end
  
  def finalize_angular_stylesheets
    
    return if skip_method(__method__)
    
    # integrate the angular styles into the application.css in the right order
    filename = "#{destination}/../stylesheets/application.css"
    
    content = File.read(filename)
    
    libs = "*= require angular-ui
 *= require select2
 *= require bootstrap
 *= require bootstrap-responsive
 *= require font-awesome.min
 *= require font-awesome-ie7.min
 *= require style
 *= require jquery-ui
 *= require toastr
    "
=begin

=end    
    unless content.include? libs
      content.sub!(/require_self\s*$/) {|matched| matched + "\n#{libs}"}
    end
    
    write_artifact("../stylesheets/application.css",content) 
  end

end
