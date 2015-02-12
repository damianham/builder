class UIrouterBuilder < RestAngularBuilder
  
  def build_view 
    return if skip_method(__method__)
     
    build_form_partial 'uirouter', 'FormCtrl'
    
    build_detail_partial 'uirouter', 'DetailCtrl'     
    
    build_list_partial 'uirouter'
    
    build_table_partial 'uirouter'
    
    build_grid_partial 'uirouter'
    
    build_list_route 'uirouter', 'ListCtrl'
  end
  
  # override the base method to add the state name to the route options
  def build_list_route prefix, controller
    
    filename = "#{singular_table_name}/#{prefix}_#{list_type}.html"
    
    # add a route for the list 
    @@ng_routes << {
      :name => "#{plural_table_name}.list",
      :template => '/' + module_path('views', filename),
      :controller => model_name + controller,
      :url => ''
    }
  end
  
  def finalize_modules
    
    return if skip_method(__method__)
    
    @@ng_modules.each do |mod|
    
      filename = "#{mod.model_name}Module.js"
      path = module_path("modules",filename)
      puts "build Ng module for #{mod.model_name} in #{path}"
      
      template = File.read(template(File.join("restangular","uirouter_module.js.erb")))

      module_text = Erubis::Eruby.new(template).evaluate( mod )

      # generate the output
     
      write_asset(path,module_text)
    end
    
  end
  
  # create the main app module
  def finalize_angular_app
    
    # calling this before skip method check means either can be skipped
    create_controller_methods
    
    return if skip_method(__method__)
    
    filename = (appname || namespace || "app") + ".js"
    path = module_path("app",filename)
    puts "finalize Ng app in #{path}"
 
    template = File.read(template(File.join("restangular","uirouter_app.js.erb")))
    
    text = Erubis::Eruby.new(template).evaluate( self )

    # write the routes output
    write_asset(path,text) 
    
  end
  
end