require 'yaml'
require 'fileutils'

# build AngularJS (Ng) artifacts using Restangular with modal dialogs


class RestAngularModalBuilder < RestAngularBuilder
  
  def build_view 
    return if skip_method(__method__)
    
    build_modal_form_partial
    
    build_modal_detail_partial     
    
    build_modal_list_partial
  end
  
  def build_modal_form_partial
    
    return if skip_method(__method__)

    template = File.read(template("ng/modal-form.erb"))
    
    filename = "#{singular_table_name}/modal_form.html"
    
    path =  module_path("views",filename)
    puts "build Ng form partial for #{model_name} in #{path}"
    
    text = Erubis::Eruby.new(template).evaluate( self )
    
    # add a route for this partial
    @@ng_routes << {
      :template => '/' + module_path('views', filename),
      :controller => model_name + 'ModalCtrl',
      :url => '/' + namespaced_url(plural_table_name) + '/new'
    }
    @@ng_routes << {
      :template => '/' + module_path('views', filename),
      :controller => model_name + 'ModalCtrl',
      :url => '/' + namespaced_url(plural_table_name) + '/:' + singular_table_name + 'Id/edit'
    }
  
      
    # generate the output
    
    write_view(path,text)
  end
  
  def build_modal_detail_partial  
    
    return if skip_method(__method__)

    template = File.read(template("ng/modal-detail.erb"))
    
    filename = "#{singular_table_name}/modal_detail.html"
    
    path =  module_path("views",filename)
    puts "build Ng detail partial for #{model_name} in #{path}"
    
    text = Erubis::Eruby.new(template).evaluate( self )
    
    # add a route for this partial
    @@ng_routes << {
      :template => '/' + module_path('views', filename),
      :controller => model_name + 'DetailCtrl',
      :url => '/' + namespaced_url(plural_table_name) + '/:' + singular_table_name + 'Id'
    }
      
    # generate the output
    
    write_view(path,text)

  end
  
  def build_modal_list_partial 
    
    return if skip_method(__method__)
    
    template = File.read(template("ng/modal-#{LIST_TYPE}.erb"))
    
    filename = "#{singular_table_name}/modal_list.html"
    
    path = module_path("views",filename)
    puts "build Ng #{LIST_TYPE} list partial for #{model_name} in #{path}"
    
    text = Erubis::Eruby.new(template).evaluate( self )
    
    # add a route for this partial
    @@ng_routes << {
      :template => '/' + module_path('views', filename),
      :controller => model_name + 'ModalCtrl',
      :url => '/' + namespaced_url(plural_table_name) 
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
      
      template = File.read(template(File.join("restangular","modal_module.js.erb")))

      module_text = Erubis::Eruby.new(template).evaluate( mod )

      # generate the output 
     
      write_asset(path,module_text)
    end
    
  end
  
end
