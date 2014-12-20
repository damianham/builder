

# define the builders with their output destinations
# 

@builders = {
  RailsBuilder => {:output => './mywebapp'  },
  AngularRailsBuilder => {:output => './mywebapp'}
}

=begin

We can also add :only and :except elements to the hash which are both arrays of 
method name symbols.  If the :only option exists then only methods named in the 
:only array will do anything, all other methods will return immediately.  Any 
methods named in the :except array will do nothing and return immediately.

@builders = {
  RailsBuilder => {:output => './mywebapp' ,
  # do not do anything for these methods
  :except => [:finalize_angular_root, :build_model, :build_controller] },
  
  AngularRailsBuilder => {:output => './mywebapp/app/assets/javascripts',
  # don't do anything except finalize the menu
  :only => [:finalize_menu]}
}
=end
# use RailsVanillaBuilder instead of RailsBuilder 
# for standard rails artifacts using the rails scaffold generator

# define the tables to ignore e.g. IGNORE_TABLES = ['dodgy_table1','dummy_table2']
IGNORE_TABLES = []

