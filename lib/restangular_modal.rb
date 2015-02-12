
# build AngularJS (Ng) artifacts using Restangular with modal dialogs


class RestAngularModalBuilder < RestAngularBuilder
  

  def build_view 
    return if skip_method(__method__)
     
    build_form_partial 'modal', 'ModalCtrl'
    
    build_detail_partial 'modal', 'DetailCtrl'     
    
    build_list_partial 'modal'
    
    build_table_partial 'modal'
    
    build_grid_partial 'modal'
    
    build_list_route 'modal', 'ModalCtrl'
  end
  
  
  def finalize_modules
    
    return if skip_method(__method__)
    
    @@ng_modules.each do |mod|
    
      filename = "#{mod.model_name}Module.js"
      path = module_path("modules",filename)
      puts "build Ng module for #{mod.model_name} in #{path}"
      
      template = File.read(template(File.join("restangular","modal_module.js.erb")))

      module_text = Erubis::Eruby.new(template).evaluate( mod )

      # generate the output 
     
      write_asset(path,module_text)
    end
    
  end
  
end
