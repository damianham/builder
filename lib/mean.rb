
# build MEAN (Mongo,Express,Angular,Node) artifacts


class MeanBuilder < Builder::Base
  
  def bson_default_value default, type
    return "'#{default}'" unless default.nil?
    case type
    when :datetime, :timestamp, :time, :date   then 'Date.now'
    when :boolean,:tinyint            then 'false'
    else
      nil
    end
  end
=begin
mongoose types
String
Number
Date
Buffer
Boolean
Mixed
ObjectId
Array
=end  
  def bson_data_type type
    case type
    when :int,:integer                then 'Number'
    when :float, :decimal             then "Number"
    when :datetime, :timestamp, :time, :date                        then 'Date'
    when :string, :char, :varchar     then "String"
    when :text                        then "String"
    when :boolean,:tinyint            then 'Boolean'
    when :point                       then 'Array'
     
    else
      raise "cannot determine BSON data type for #{type}"
    end
  end
  
  def setup
    @@ng_routes = []
    @@menus = []
    @@ng_modules = []
  end
  
  def build_server_controller 
    return if skip_method(__method__)

    filename = plural_table_name + '.server.controller.js'
    
    template_path = File.join("mean","server_controller.js.erb")
    destination = File.join("app","controllers")
    description = 'MEAN server controller'

    build_artifact(template_path,filename,destination,description)

  end
  
  def build_client_controller 
    return if skip_method(__method__)

    filename = plural_table_name + '.client.controller.js'
    
    template_path = File.join("mean","client_controller.js.erb")
    destination = File.join("public",'modules',plural_table_name,"controllers")
    description = 'MEAN client controller'

    build_artifact(template_path,filename,destination,description)
  
  end
  
  def build_controller 
    return if skip_method(__method__)

    build_server_controller
    
    build_client_controller
    
    @@ng_modules << self
  
  end

  def build_server_route
    return if skip_method(__method__)

    filename = plural_table_name + '.server.routes.js'
    
    template_path = File.join("mean","server_routes.js.erb")
    destination = File.join("app","routes")
    description = 'MEAN server route'

    build_artifact(template_path,filename,destination,description)

  end
  
  def build_client_route
    return if skip_method(__method__)

    filename = plural_table_name + '.client.routes.js'
    
    template_path = File.join("mean","client_routes.js.erb")
    destination = File.join("public",'modules',plural_table_name,"config")
    description = 'MEAN client route'

    build_artifact(template_path,filename,destination,description)

  end
  
  def build_route
    return if skip_method(__method__)
    
    build_server_route
    build_client_route
    
  end

  def build_server_model
    return if skip_method(__method__)

    filename = singular_table_name + '.server.model.js'
    
    template_path = File.join("mean","server_model.js.erb")
    destination = File.join("app","models")
    description = 'MEAN server model'

    build_artifact(template_path,filename,destination,description)
  end
  
  def build_client_service
    return if skip_method(__method__)
    
    filename = plural_table_name + '.client.service.js'
    
    template_path = File.join("mean","client_service.js.erb")
    destination = File.join("public",'modules',plural_table_name,"services")
    description = 'MEAN client service'

    build_artifact(template_path,filename,destination,description)
  end

  def build_model
    return if skip_method(__method__)
    
    build_server_model
    build_client_service

  end
  
  
  def build_list_view
    return if skip_method(__method__)
    
    filename = 'list-'+ plural_table_name + '.client.view.html'
    
    template_path = File.join("mean","list_client_view_html.erb")
    destination = File.join("public",'modules',plural_table_name,"views")
    description = 'MEAN client list view'

    build_artifact(template_path,filename,destination,description)
    
  end
  
  def build_create_view
    return if skip_method(__method__)
    
    filename = 'create-'+ singular_table_name + '.client.view.html'
    
    template_path = File.join("mean","create_client_view_html.erb")
    destination = File.join("public",'modules',plural_table_name,"views")
    description = 'MEAN client create view'

    build_artifact(template_path,filename,destination,description)
    
  end
  
  def build_edit_view
    return if skip_method(__method__)
    
    filename = 'edit-'+ singular_table_name + '.client.view.html'
    
    template_path = File.join("mean","edit_client_view_html.erb")
    destination = File.join("public",'modules',plural_table_name,"views")
    description = 'MEAN client edit view'

    build_artifact(template_path,filename,destination,description)
    
  end
  
  def build_show_view
    return if skip_method(__method__)
    
    filename = 'view-'+ singular_table_name + '.client.view.html'
    
    template_path = File.join("mean","view_client_view_html.erb")
    destination = File.join("public",'modules',plural_table_name,"views")
    description = 'MEAN client show view'

    build_artifact(template_path,filename,destination,description)
    
  end

  def build_view 
    return if skip_method(__method__)
    
    build_create_view
    build_edit_view
    build_list_view
    build_show_view
       
  end


  def build_unit_test 
    return if skip_method(__method__)
    
    filename = singular_table_name + '.server.model.test.js'
    
    template_path = File.join("mean","server_model_test.js.erb")
    destination = File.join("app","tests")
    description = 'MEAN model test'

    build_artifact(template_path,filename,destination,description)
  end

  def build_routes_test 
    return if skip_method(__method__)
    
    filename = singular_table_name + '.server.routes.test.js'
    
    template_path = File.join("mean","server_route_test.js.erb")
    destination = File.join("app","tests")
    description = 'MEAN route test'

    build_artifact(template_path,filename,destination,description)
    
  end
  
  def build_e2e_test 
    return if skip_method(__method__)
    
    filename = plural_table_name + '.client.controller.test.js'
    
    template_path = File.join("mean","client_controller_test.js.erb")
    destination = File.join("public",'modules',plural_table_name,"tests")
    description = 'MEAN client controller test'

    build_artifact(template_path,filename,destination,description)
  end

  def build_test_fixtures 
    return if skip_method(__method__)
    puts "build fixture for #{model_name} in test/fixtures not yet implemented"
  end
  
  def build_test
    return if skip_method(__method__)
    build_test_fixtures
    build_routes_test
    build_unit_test
    build_e2e_test
  end
  
  def build_menu
    
    return if skip_method(__method__)

    filename = plural_table_name + '.client.config.js'
    
    template_path = File.join("mean","client_config.js.erb")
    destination = File.join("public",'modules',plural_table_name,"config")
    description = 'MEAN client config'

    build_artifact(template_path,filename,destination,description)
    
  end

  def finalize_artifacts
    
    return if skip_method(__method__)
        
    # create the angular modules
    finalize_modules
    
    
  end
  
  def finalize_modules
    
    return if skip_method(__method__)
    
    @@ng_modules.each do |mod|
    
      filename = "#{mod.plural_table_name}.client.module.js"
    
      template_path = File.join("mean","client_module.js.erb")
      destination = File.join("public",'modules',mod.plural_table_name)
      description = 'MEAN client module'

      text = Erubis::Eruby.new(File.read(template(template_path))).evaluate( mod )
      
      path = namespaced_path(destination,filename)
      puts "build #{description} for #{model_name} in #{path}"
      write_artifact(path,text)
    end
    
  end
 
  
end
