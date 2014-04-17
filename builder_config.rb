

# define the builders with their output destinations
# 

@builders = {
  RailsBuilder => {:output => './myapp'  },
  AngularRailsBuilder => {:output => './myapp/app/assets/javascripts'
}
}

# use RailsVanillaBuilder instead of RailsBuilder 
# for standard rails artifacts using the rails scaffold generator

# define the tables to ignore e.g. IGNORE_TABLES = ['dodgy_table1','dummy_table2']
IGNORE_TABLES = []

