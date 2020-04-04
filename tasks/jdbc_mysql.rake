#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require 'rubygems'
require 'yaml'
require 'jdbc/mysql'
require "java"

Jdbc::MySQL.load_driver


desc "Build the schema definition file from the database schema using JDBC connection"

# to specify default values,
# we take advantage of args being a Rake::TaskArguments object
task :build_schema, :host, :database, :username, :password do |t, args|
  args.with_defaults( :username => "test", :password => "test")
  puts "Args with defaults were: #{args}"

  rel_columns = "column_name,referenced_table_schema,referenced_table_name,referenced_column_name"
  column_fields = "column_name,ordinal_position,data_type,is_nullable,character_maximum_length,numeric_precision,column_comment"
  result = {'schema' => {}}

  # create the schema object then export to a yaml file

  # Prep the connection
  Java::com.mysql.jdbc.Driver
  userurl = "jdbc:mysql://#{args['host']}/information_schema"
  connSelect = java.sql.DriverManager.get_connection(userurl, args['username'], args['password'])
  stmtSelect = connSelect.create_statement
  colSelect = connSelect.create_statement

  rsS = stmtSelect.execute_query("SELECT TABLE_NAME,TABLE_COMMENT FROM TABLES WHERE TABLE_SCHEMA = '#{args['database']}'" )

  count = 0
  while (rsS.next) do
    next if rsS.getObject('TABLE_NAME') == 'schema_migrations' || rsS.getObject('TABLE_NAME') == 'play_evolutions'

    comment = rsS.getObject('TABLE_COMMENT') || ""

    puts rsS.getObject('TABLE_NAME') + " " + comment

    comment = comment.gsub(/\r/," ")
    comment = comment.gsub(/\n/," ")

    result['schema'][rsS.getObject('TABLE_NAME')] = {'columns' => {}, 'has_many' => {}, 'belongs_to' => {}, 'comment' => comment}

    columns = colSelect.execute_query("SELECT #{column_fields} FROM COLUMNS WHERE TABLE_SCHEMA = '#{args['database']}' AND TABLE_NAME = '#{rsS.getObject('TABLE_NAME')}'" )

    while (columns.next) do
      col = {}
      column_fields.split(',').each {|field| col[field] = columns.getObject(field)}
      result['schema'][rsS.getObject('TABLE_NAME')]['columns'][columns.getObject('column_name')] = col
    end

  end

  result['schema'].each { |table|
    puts "get index data for #{table[0]}"

    foreigns = stmtSelect.execute_query("SELECT #{rel_columns} FROM KEY_COLUMN_USAGE WHERE TABLE_SCHEMA = '#{args['database']}' AND TABLE_NAME = '#{table[0]}' ")

    while (foreigns.next) do

      reltablename = foreigns.getObject('referenced_table_name')
      relcolname = foreigns.getObject('referenced_column_name')
      colname = foreigns.getObject('column_name')

      # ignore primary key columns that dont reference anything
      next if relcolname == nil

      # add the has_many to the parent
      puts "add has_many #{table[0]} to #{reltablename} "
      result['schema'][reltablename]['has_many'][table[0]] = 1
      result['schema'][table[0]]['belongs_to'][reltablename] = 1

      # add the belongs_to to this child
      result['schema'][table[0]]['columns'][colname]['references'] = "#{reltablename}.#{relcolname}"
    end
  }

  # Close off the connection
  stmtSelect.close
  colSelect.close
  connSelect.close

  filename = args['database'] + '_column_info.yml'

  # generate the output
  File.open(filename,"w") do |f|
      f.write(result.to_yaml)
  end

end

