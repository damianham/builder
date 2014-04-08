#!/usr/bin/env rake

require 'rubygems'
require 'yaml'

require File.expand_path( '../builder.rb', File.dirname(__FILE__)  )
 
require './builder_config'
 
def build_unit(table_name,columns)

  @builders.each_pair do |klass,output|
    builder = klass.new(output,table_name,columns)

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

end

desc "Build the classes"

task :build_classes, :database do |t, args|

  puts "Args with defaults were: #{args}"

  filename = args['database'] + '_column_info.yml'

  schema = YAML.load_file(filename)
  schema['schema'].each_pair do |table_name, columns|

    # build the artifacts for this table
    build_unit(table_name, columns) unless IGNORE_TABLES.include?(table_name)

  end
  
  # finalize the builder 
  @builders.each_pair do |klass,output|
    builder = klass.new(output,'dummy',{'columns' => {}})
    
    # build the artifacts that contain data for all classes e.g. menus
    builder.finalize_artifacts

  end

end
