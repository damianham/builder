#!/usr/bin/env rake

require 'rubygems'
require 'yaml'

require File.expand_path( '../builder.rb', File.dirname(__FILE__)  )
 
require './builder_config'
 
def build_unit(context,table_name,columns)

  @builders.each_pair do |klass,options|
    
    

  end

end

desc "Build the classes"

task :build_classes, :database do |t, args|

  #puts "Args with defaults were: #{args}"

  filename = args['database'] + '_column_info.yml'

  schema = YAML.load_file(filename)
  
  @builders.each_pair do |klass,options|
    
    builder = nil
    
    schema['schema'].each_pair do |table_name, columns|

      next if IGNORE_TABLES.include?(table_name)
      
      table_options = options.merge( { :name => table_name, :schema => columns})
      
      # build the artifacts for this table
      builder = klass.new(table_options)

      if builder.respond_to? :scaffold
        builder.scaffold
      else
        builder.build_controller
        builder.build_model
        builder.build_view
        builder.build_test
        builder.build_menu
        builder.build_route
      end

    end
  
    # finalize the builder using the last instantiated builder
    # build the artifacts that contain data for all classes e.g. menus
    builder.finalize_artifacts

  end

end
