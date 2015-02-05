require 'yaml'
require 'fileutils'

# build AngularJS (Ng) artifacts using Restangular


class RestAngularBuilder < AngularRailsBuilder
  
  def build_model
    # build an angular resource
    filename = "#{model_name}Resource.js"
      path = module_path("resources",filename)
      puts "build Ng resource for #{model_name} in #{path}"
      
      template = File.read(template(File.join("restangular","resource.js.erb")))

      module_text = Erubis::Eruby.new(template).evaluate( self )

      # generate the output 
     
      write_asset(path,module_text)

  end
  
  def finalize_modules
    
    return if skip_method(__method__)
    
    @@ng_modules.each do |mod|
    
      filename = "#{mod.model_name}Module.js"
      path = module_path("modules",filename)
      puts "build Ng module for #{mod.model_name} in #{path}"
      
      template = File.read(template(File.join("restangular","module.js.erb")))

      module_text = Erubis::Eruby.new(template).evaluate( mod )

      # generate the output 
     
      write_asset(path,module_text)
    end
    
  end
  
  # add the generated javascripts to application.js
  def finalize_angular_app
    
    return if skip_method(__method__)
    
    filename = (appname || namespace || "app") + ".js"
    path = module_path("app",filename)
    puts "finalize Ng app in #{path}"
 
    template = File.read(template(File.join("restangular","app.js.erb")))
    
    text = Erubis::Eruby.new(template).evaluate( self )

    # write the routes output
    write_asset(path,text) 
    
  end
  
end
