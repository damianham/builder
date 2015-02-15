

# define the builders with their output destinations
# javascript modules are written to $output/app/assets/javascripts/generated/modules
# html view templates are written to $output/public/generated/partials 
# and $output/public/generated/views
# Rails and Rspec artifacts are written to $output/generated

@builders = {
  RailsBuilder => {:output => './mywebapp/rails',:appname => 'myapp', :namespace => 'api'  },
  RSpecBuilder => {:output => './mywebapp/rails',:appname => 'myapp', :namespace => 'api'},
  
  AngularRailsBuilder => {:output => './mywebapp/ng',:appname => 'myapp',
   :except => [:finalize_application], :api_prefix => 'api/'
  },
 
  RestAngularBuilder => {:output => './mywebapp/restangular',:appname => 'myapp',
  :except => [:finalize_application], :api_prefix => 'api/'
  },

  RestAngularModalBuilder => {:output => './mywebapp/modal',:appname => 'myapp',
  :except => [:finalize_application], :api_prefix => 'api/'
  },
  
  UIrouterBuilder  => {:output => './mywebapp/uirouter',:appname => 'myapp',
  :except => [:finalize_application], :api_prefix => 'api/'
  },
  MeanBuilder  => {:output => './mywebapp/mean',:appname => 'myapp',
  :except => [:finalize_application], :api_prefix => 'api/'
  }
  
}

@fields = {
  :except => [:id,:created_at,:updated_at],
  :detail => {   },
  :form => {  },
  :list => {  }
}

=begin

We can also add :only and :except elements to the hash which are both arrays of 
method name symbols.  If the :only option exists then only methods named in the 
:only array will do anything, all other methods will return immediately.  Any 
methods named in the :except array will do nothing and return immediately.

@builders = {
  RailsBuilder => {:output => './mywebapp' ,:appname => 'myapp',
  # do not do anything for these methods
  :except => [:finalize_menu, :build_model, :build_controller] },
  
  AngularRailsBuilder => {:output => './mywebapp',:appname => 'myapp',
  # don't do anything except finalize the menu
  :only => [:finalize_menu]}
}

We can also specify the fields to display for each type of display, e.g
@fields = {
  :except => [:id,:created_at,:updated_at],
  :detail => {
    :users => [:email,:gender,:birthday]
  },
  :form => {
    :users => [:email,:name,:gender,:birthday]
  },
  :list => {
    :users => [:email,:name,:gender,:birthday],
    :places => [:lat,:long,:map_link]
    }
}

=end
# use RailsVanillaBuilder instead of RailsBuilder 
# for standard rails artifacts using the rails scaffold generator

# define the tables to ignore e.g. IGNORE_TABLES = ['dodgy_table1','dummy_table2']
# schema_migrations is ignored by the schema extractor task
IGNORE_TABLES = ['friendly_id_slugs']


# define the template type for all index routes e.g. /users
 # define to 'list' to use the list template
 # or 'table' to use the table template
 LIST_TYPE = 'table'