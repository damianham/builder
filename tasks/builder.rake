#!/usr/bin/env rake

require 'rubygems'
require 'yaml'

require File.expand_path( '../builder.rb', File.dirname(__FILE__)  )

config_file = ENV['conf'] || './builder_config'

require config_file

desc "Build the classes"

task :build_classes, :database,:namespace do |t, args|

  #puts "Args with defaults were: #{args}"

  filename = ENV['columns'] || args['database'] + '_column_info.yml'

  schema = YAML.load_file(filename)
  
  @builders.each_pair do |klass,options|
    
    builder = nil
    
    options.merge!( { :namespace => args['namespace'] }) unless args['namespace'].nil? 
    
    schema['schema'].each_pair do |table_name, table_info|

      next if IGNORE_TABLES.include?(table_name)
      
      table_options = options.merge( { :name => table_name.tableize, 
          :schema => schema['schema'],
          :table_info => table_info, :fields => @fields })
      
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
