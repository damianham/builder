class UIrouterBuilder < RestAngularBuilder
  
  def build_view 
    return if skip_method(__method__)
    
    build_uirouter_list_partial
    
    build_uirouter_form_partial
    
    build_uirouter_detail_partial     
    
  end
  
  def build_uirouter_form_partial
    
    return if skip_method(__method__)

    template = File.read(template("ng/uirouter-form.erb"))
    
    filename = "#{singular_table_name}/uirouter_form.html"
    
    path =  module_path("views",filename)
    puts "build Ng form partial for #{model_name} in #{path}"
    
    text = Erubis::Eruby.new(template).evaluate( self )
    
    # add a route for this partial
    @@ng_routes << {
      :name => "#{plural_table_name}.new",
      :template => '/' + module_path('views', filename),
      :controller => model_name + 'FormCtrl',
      :url => '/new'
    }
    @@ng_routes << {
      :name => "#{plural_table_name}.edit",
      :template => '/' + module_path('views', filename),
      :controller => model_name + 'FormCtrl',
      :url => '/:' + singular_table_name + 'Id/edit'
    }
  
      
    # generate the output
    
    write_view(path,text)
  end
  
  def build_uirouter_detail_partial  
    
    return if skip_method(__method__)

    template = File.read(template("ng/uirouter-detail.erb"))
    
    filename = "#{singular_table_name}/uirouter_detail.html"
    
    path =  module_path("views",filename)
    puts "build Ng detail partial for #{model_name} in #{path}"
    
    text = Erubis::Eruby.new(template).evaluate( self )
    
    # add a route for this partial
    @@ng_routes << {
      :name => "#{plural_table_name}.detail",
      :template => '/' + module_path('views', filename),
      :controller => model_name + 'DetailCtrl',
      :url => '/:' + singular_table_name + 'Id'
    }
      
    # generate the output
    
    write_view(path,text)

  end
  
  def build_uirouter_list_partial 
    
    return if skip_method(__method__)
    
    template = File.read(template("ng/uirouter-#{LIST_TYPE}.erb"))
    
    filename = "#{singular_table_name}/uirouter_list.html"
    
    path = module_path("views",filename)
    puts "build Ng #{LIST_TYPE} list partial for #{model_name} in #{path}"
    
    text = Erubis::Eruby.new(template).evaluate( self )
    
    # add a route for this partial
    @@ng_routes << {
      :name => "#{plural_table_name}.list",
      :template => '/' + module_path('views', filename),
      :controller => model_name + 'ListCtrl',
      :url => ''  
    }
    
    # generate the output
    
    write_view(path,text)

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