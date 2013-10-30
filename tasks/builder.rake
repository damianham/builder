#!/usr/bin/env rake

require 'rubygems'
require 'yaml'

require File.expand_path( '../builder.rb', File.dirname(__FILE__)  )

@builders = [RailsBuilder,AngularRailsBuilder]  
# use RailsVanillaBuilder instead for standard rails artifacts using the rails scaffold generator

# define the output destinations
OUTPUT_FOLDERS = {
  RailsBuilder => './myapp',
  AngularRailsBuilder => './myapp/app/assets/javascripts'
}

# define the tables to ignore e.g. IGNORE_TABLES = ['dodgy_table1','dummy_table2']
IGNORE_TABLES = []

def build_unit(table_name,columns)

  @builders.each do |klass|
    builder = klass.new(OUTPUT_FOLDERS[klass],table_name,columns)

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
  @builders.each do |klass|
    builder = klass.new(OUTPUT_FOLDERS[klass],'dummy',{'columns' => {}})
    
    # build the artifacts that contain data for all classes e.g. menus
    builder.finalize_artifacts

  end

end
