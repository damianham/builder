

# define the builders with their output destinations
# :namespace - create the artifacts in namespace subfolders
# 

@builders = {
  RailsBuilder => {:output => './myapp', :namespace => 'mynamespace' },
  AngularRailsBuilder => {:output => './myapp/app/assets/javascripts', 
    :namespace => 'mynamespace'}
}

# use RailsVanillaBuilder instead of RailsBuilder 
# for standard rails artifacts using the rails scaffold generator

# define the tables to ignore e.g. IGNORE_TABLES = ['dodgy_table1','dummy_table2']
IGNORE_TABLES = []

