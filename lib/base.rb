module Builder
  
  class Base
    
    RESERVED_YAML_KEYWORDS = %w(y yes n no true false on off null)
    
      attr_accessor :singular_table_name, :plural_table_name, :human_name, 
        :schema, :model_name, :controller_name, :attributes, :destination
  
   
    def initialize(destination,name,schema)
      @destination ||= destination
      @schema = schema
      @singular_table_name = name.singularize
      @human_name = @singular_table_name.humanize
      @plural_table_name = name.pluralize
      @model_name = name.to_model_name
      @controller_name = name.to_controller_name
      
      @attributes = schema['columns'].map{|col| 
        FieldDefinition.new(col[1])}.reject{|col| col.name == "id"}
        
        puts "initialize " + self.class.name + " with " +destination
    end
  
    def columns
     schema['columns']
    end
   
    def yaml_key_value(key, value)
     if RESERVED_YAML_KEYWORDS.include?(key.downcase)
       "'#{key}': #{value}"
     else
       "#{key}: #{value}"
     end
    end
   
    # write content to a file ensuring the enclosing folder exists
    def write_artifact(filepath,filename,content = nil)
    
      # ensure the target folder exists
      FileUtils.mkdir_p("#{destination}/#{filepath}")
    
      filename = "#{destination}/#{filepath}/#{filename}"
      
      puts "write to " + filename
    
      # write the given content or yield the open output file to a block
      File.open(filename, 'wb') { |file| 
        if block_given?
          yield file
        else
          file.write(content)
        end        
      }
    
    end

    # generate a file path to a named template
    def template(filename)
      File.expand_path("../../templates", __FILE__) + "/#{filename}"
    end
    
    # default implementations that do nothing
    def build_controller 
    end
    
    def build_model
    end
    
    def build_view
    end
    
    def build_test
    end
    
    def build_menu
    end
    
    def build_route
    end
    
    def finalize_artifacts
    end
  
  end  # end class Base
  
   
  class FieldDefinition
    
    def initialize(field)
      @field = field
    end
    
    def type
      @field['data_type'].to_sym
    end
    
    def name
      @field['column_name']
    end
    
    def column_name
      name
    end
    
    def human_name
      name.titleize
    end
    
    def polymorphic?
      nil
    end
    
    def field_type
      @field_type ||= case type
      when :int,:integer         then :number_field
      when :float, :decimal      then :text_field
      when :time                 then :time_select
      when :datetime, :timestamp then :datetime_select
      when :date                 then :date_select
      when :text                 then :text_area
      when :boolean,:tinyint     then :check_box
      else
      :text_field
      end
    end

    def default
      @default ||= case type
      when :int,:integer                then 1
      when :float                       then 1.5
      when :decimal                     then "9.99"
      when :datetime, :timestamp, :time then Time.now.to_s
      when :date                        then Date.today.to_s
      when :string, :char, :varchar     then name == "type" ? "" : "MyString"
      when :text                        then "MyText"
      when :boolean,:tinyint            then false
      when :references, :belongs_to     then nil
      else
      ""
      end
    end
    
    def password_digest?
      name == 'password' && type == :digest
    end

  end

end