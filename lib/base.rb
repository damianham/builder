module Builder
  
  class Base
    
    RESERVED_YAML_KEYWORDS = %w(y yes n no true false on off null)
    
    attr_accessor :namespace, :singular_table_name, :plural_table_name, :human_name, 
      :schema, :model_name, :controller_name, :attributes, :destination, :appname,
      :table_info, :fields, :this_fields, :namefield_name, :descfield_name,
      :field_list
  
   
    def initialize(options)
      
      @destination ||= options[:output]
      puts "initialize " + self.class.name + " with #{destination}" 
      
      @options = options
      @namespace ||= options[:namespace]
      @appname ||= options[:appname]
      
      @schema = options[:schema]
      @table_info = options[:table_info]
      @fields = options[:fields] || {}
      
      name = options[:name]
      @singular_table_name = name.singularize
      @human_name = @singular_table_name.humanize
      @plural_table_name = name.pluralize
      @model_name = name.to_model_name
      @controller_name = name.to_controller_name
      
      @attributes = table_info['columns'].map{|col| 
        FieldDefinition.new(col[1])}.reject{|col| @fields.fetch(:except,[]).include?(col.name.to_sym) }
      
      @this_fields = # extract the partial fields for this class and remove null entries
      {:except => @fields.fetch(:except,nil),
        :detail => @fields.fetch(:detail,Hash.new).fetch(name.to_sym,nil),
        :form => @fields.fetch(:form,Hash.new).fetch(name.to_sym,nil),
        :list => @fields.fetch(:list,Hash.new).fetch(name.to_sym,nil),
      }.reject{|k,v| v.nil?}
            
      # find the first non ID column
      default_namefield = @attributes.reject{|col| col.name =~ /_id$/}.first

      # determine the display field names
      namefield = @attributes.select{|col| ['name','title'].include?(col.name)}.first || default_namefield
      descfield = @attributes.select{|col|['description','info',
          'summary','comment','snippet'].include?(col.name) }.first

      # convert the column array into a list of field names
      @field_list = attributes.map{|col| col.name  }

      @namefield_name = namefield.nil? ? nil : namefield.name
      @descfield_name = descfield.nil? ? nil : descfield.name

    end
    
    # skip the named method based on the contents of the :only and :except options
    def skip_method(methodname)
      (@options[:only] && ! @options[:only].include?(methodname) ) || 
        (@options[:except] && @options[:except].include?(methodname))
    end
  
    def columns
      table_info['columns']
    end
   
    def yaml_key_value(key, value)
      if RESERVED_YAML_KEYWORDS.include?(key.downcase)
        "'#{key}': #{value}"
      else
        "#{key}: #{value}"
      end
    end
    
    # namespace is prefix
    def module_path(filepath,filename)
      
      path = "#{filepath}/#{filename}"
      if ! namespace.nil?
        path = "#{namespace}/#{filepath}/#{filename}"
      end
      path
    end
    
    # namespace is infix
    def namespaced_path(filepath,filename)
      
      path = "#{filepath}/#{filename}"
      if ! namespace.nil?
        path = "#{filepath}/#{namespace}/#{filename}"
      end
      path
    end
    
    def angular_url(url_path)
      '/#/' + namespaced_url(url_path)
    end
    
    def namespaced_url(url_path)
      result = url_path
      if ! namespace.nil?
        result =  namespace + '/' + url_path
      end
      result
    end
   
    # write content to a file ensuring the enclosing folder exists
    def write_file(path,content = nil, block=nil)
      # ensure the target folder exists
      FileUtils.mkdir_p(File.dirname(path))
      
      #puts "write to " + path
    
      # write the given content or yield the open output file to a block
      File.open(path, 'wb') { |file| 
        if content.nil?
          block.call file
        else
          file.write(content)
        end        
      }
    end
    
    def write_asset(filename,content = nil, &block)
    
      path = "#{destination}/app/assets/javascripts/#{filename}"
      write_file(path,content, block)      
    
    end
    
    def write_partial(filename,content = nil, &block)
    
      path = "#{destination}/public/#{filename}"
      
      write_file(path,content, block)
    
    end
    
    def write_artifact(filename,content = nil, &block)
    
      path = "#{destination}/#{filename}"
       
      write_file(path,content, block)
    
    end

    # generate a file path to a named template
    def template(filename)
      File.expand_path("../../templates", __FILE__) + "/#{filename}"
    end
    
    # getter/setter of hash values
    def method_missing(method,*args, &block)

      if @options.nil?
        return super
      end

      # ensure methodname is a String not a Symbol
      methodname = method.id2name

      # ensure there is no leading/trailing spaces
      methodname.strip!

      if methodname[-1] == 61   # '=' character
        methodname.chop!
        result = @options.store(methodname.to_sym,*args)
      elsif @options.has_key? method
        result = @options.fetch(method)
      else
        raise("invalid option name " + methodname)
      end

      result
    end
  
    def form_attributes(column)
      attributes = [
        "name='#{column['column_name']}'" ,
        "class='form-control'",
        "placeholder='#{column['column_comment']}'",
        "ng-model='#{singular_table_name}.#{column['column_name']}'"
      ]
      
      if column['data_type'] == 'int'
        attributes << "min='0' max='4294967295'"   # max unsigned int
        attributes << 'integer'
      elsif column['data_type'] == 'char' || column['data_type'] == 'varchar'
        attributes << "ng-maxlength='#{column['character_maximum_length']}'"
      end
       
      attributes << 'required' if column['is_nullable'] == 'NO'
      
      attributes
    end
    
    # if this field_name is suffixed with '_id' and there is a matching key in the
    # belongs_to hash 
    def is_foreign_key?(field_name)
      return false unless field_name =~ /\w*_id$/ 
      relation = field_name.gsub(/_id$/,'').pluralize
      table_info['belongs_to'].flatten.include? relation 
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