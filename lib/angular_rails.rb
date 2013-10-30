require 'yaml'
require 'fileutils'

# build AngularJS (Ng) artifacts

class AngularRailsBuilder < Builder::Base

  @@ng_routes = []
  @@menus = []
  @@services = []
  
 
  def build_controller 
    puts "build Ng controller for #{model_name}"
    
    filename = "#{plural_table_name}.js"
    template = File.read(template("ng/controller.js.erb"))

    text = Erubis::Eruby.new(template).result(:model_name => model_name,
    :singular_table_name => singular_table_name,
    :plural_table_name => plural_table_name,
    :controller_name => controller_name,
    :model_symbol => ':' + singular_table_name,
    :schema => schema)
    
    # generate the output
    write_artifact("controllers",filename,text)
  
  end

  def build_route
    puts "build Ng route for #{model_name}"
    
    @@ng_routes << singular_table_name
    
    #Hash.new(:model_name => model_name, 
    #  :table_name => plural_table_name,
    #  :single_table_name => singular_table_name)

   end

  # model

  def build_model
    puts "build Ng model for #{model_name}"

    filename = "#{singular_table_name}.js"
    template = File.read(template("ng/model.js.erb"))

    text = Erubis::Eruby.new(template).result(:model_name => model_name,
    :singular_table_name => singular_table_name,
    :plural_table_name => plural_table_name,
    :controller_name => controller_name,
    :model_symbol => ':' + singular_table_name,
    :schema => schema)
    
    # generate the output
    write_artifact("models",filename,text)
  end

  def build_list_partial 

    filename = "#{singular_table_name}-list.html"
    puts "build Ng list partial for #{model_name} in app/partials/#{filename}"

    template = File.read(template("ng/partial-list.erb"))

    text = Erubis::Eruby.new(template).result(:model_name => model_name,
    :singular_table_name => singular_table_name,
    :plural_table_name => plural_table_name,
    :controller_name => controller_name,
    :model_symbol => ':' + singular_table_name,
    :schema => schema)
    
    # generate the output
    write_artifact("partials",filename,text)

  end

  def build_detail_partial  

    filename = "#{singular_table_name}-detail.html"
    puts "build Ng detail partial for #{model_name} in  app/partials/#{filename}"

    template = File.read(template("ng/partial-detail.erb"))

    text = Erubis::Eruby.new(template).result(:model_name => model_name,
    :singular_table_name => singular_table_name,
    :plural_table_name => plural_table_name,
    :controller_name => controller_name,
    :model_symbol => ':' + singular_table_name,
    :schema => schema)

    # generate the output
    write_artifact("partials",filename,text)

  end

  def build_view 
    build_list_partial 
    build_detail_partial 
  end


  def build_unit_test 
    puts "build unit test for #{model_name} in test/unit"
  end

  def build_e2e_test 
    puts "build e2e test for #{model_name} in test/e2e"
  end

  def build_test_fixtures 
    puts "build fixture for #{model_name} in test/fixtures"
  end
  
  def build_test
    build_test_fixtures
    build_unit_test
    build_e2e_test
  end
  
  def build_menu
    puts "build Ng menu for #{model_name}"
    @@menus << ""
  end

  def finalize_artifacts
    filename = "app.js"
 
    template = File.read(template("ng/app.js.erb"))

    text = Erubis::Eruby.new(template).result( :models => @@ng_routes)

    # write the routes output
    write_artifact("app",filename,text) 
    
    # create the navigation menu
    finalize_menu

  end
  
  def finalize_menu
    
    filename = "menu.js"
    puts "finalize Ng menu in app/js/#{filename}"

    # generate the output
    write_artifact("app",filename)  do |f|
      f.puts("'use strict';

/* Menu */")

      @@menus.each do |text|
        f.puts(text) 
      end

    end
  end

end
