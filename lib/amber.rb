require 'yaml'
require 'fileutils'

# build rails artifacts using the rails scaffold generator

class AmberBuilder < Builder::Base

  @@rails_routes = []
  @@menus = []
  @@comments = []
  

  def db_type_to_type(col)
    type = col['data_type'].to_sym
    case type 
    when :char, :varchar    then :string
    when :tinyint           then :boolean
    when :int               then :integer
    else
      type
    end
  end

  def column_text(col)
    if col.has_key?("references")
      return "#{col['column_name'].delete_suffix('_id')}:ref"
    end

    "#{col['column_name']}:#{db_type_to_type(col).to_s}"
  end

  def scaffold
  # build edit _form index new show
  
    # ignore the columns that rails adds
    attributes = table_info['columns'].values.reject{|col| 
      col['column_name'] == "id" ||
      col['column_name'] == "updated_at" ||
      col['column_name'] == "created_at"
    }
    # puts "generate for #{attributes.inspect}"
    # collect the column names and types into a set of tuples
    text = attributes.collect{|col| column_text(col) }.join(' ')
    
    puts "amber generate scaffold #{model_name} #{text}"
  
    comment = table_info['comment']
    @@menus << { :model_name => model_name, :comment => comment, :route => "/"+ plural_table_name}
    
    @@comments << { :model_name => model_name, :comment => comment, :route => "/"+ plural_table_name}


  end
  
 
  def finalize_artifacts
 
    # create the navigation menu
    # finalize_menu
    
  end


end  # end class

