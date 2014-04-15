require 'yaml'
require 'fileutils'
require 'erubis'
require 'erb'

# build rails artifacts using the rails scaffold generator

class RailsVanillaBuilder

  @@rails_routes = []
  @@menus = []
  @@comments = []
  
  attr_accessor :singular_table_name, :plural_table_name, :human_name, 
        :schema, :model_name, :controller_name, :attributes
  
  def initialize(options)
    @schema = options[:schema]
      
    name = options[:name]
    @singular_table_name = name.singularize
    @human_name = @singular_table_name.humanize
    @plural_table_name = name.pluralize
    @model_name = name.to_model_name
    @controller_name = name.to_controller_name
  end

  def db_type_to_type(type)
    case type 
    when :char, :varchar    then :string
    when :tinyint           then :boolean
    when :int               then :integer
    else
      type
    end
  end

  def scaffold
    puts "build scaffold for #{model_name}  " 
  # build edit _form index new show
  
    # ignore the columns that rails adds
    attributes = schema['columns'].values.reject{|col| 
      col['column_name'] == "id" ||
      col['column_name'] == "updated_at"
      col['column_name'] == "created_at"
    }
    
    # collect the column names and types into a set of tuples
    text = attributes.collect{|col| "#{col['column_name']}:#{db_type_to_type(col['data_type'].to_sym).to_s}" }.join(' ')
    
    puts "run rails generate scaffold #{model_name} #{text}"
    `rails generate scaffold #{model_name} #{text}`
  
    comment = schema['comment']
    puts "build menu for #{model_name} (#{comment}) in app/views/shared"
    @@menus << { :model_name => model_name, :comment => comment, :route => "/"+ plural_table_name}
    
    @@comments << { :model_name => model_name, :comment => comment, :route => "/"+ plural_table_name}


  end
  
 
  def finalize_artifacts
 
    # create the navigation menu
    finalize_menu
    
  end
  
  def finalize_menu
    
    # save the menu items in a partial for inclusion in main menu
    template = File.read("./templates/rails/menu_container.erb")
    template = Erubis::Eruby.new(template)
    text = template.result(:menus => @@menus, :comments => @@comments)
    
    filename = "app/views/shared/_menu.html.erb"
    puts "finalize menu in #{filename}"

    FileUtils.mkdir_p("app/views/shared")
    # generate the output
    File.open(filename,"w") do |f|
      f.puts(text) 
    end
    
    # create a single page that lists the database tables with their comments
    template = File.read("./templates/rails/table_index.erb")
    template = Erubis::Eruby.new(template)
    text = template.result(:menus => @@menus, :comments => @@comments)
    
    filename = "app/views/tables/index.html.erb"
    puts "finalize menu in #{filename}"

    FileUtils.mkdir_p("app/views/tables")
    # generate the output
    File.open(filename,"w") do |f|
      f.puts(text) 
    end
    
  end


end  # end class

