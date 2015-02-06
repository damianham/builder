# builder


Rake driven application builder from a database schema. 

A set of rake tasks and ruby classes to generate various types of application 
artifacts using a database schema as the 
source of data.  This is useful if you want to create a Ruby On Rails 
(with AngularJS) application and you already have a legacy database or you 
prefer to create the database DDL manually to take advantage of the powerful 
features of your database engine.

Writing a web application often means writing lots of boilerplate code.  The Rails
scaffold generator can be used to generate much of the boilerplate code which is very useful, 
especially for the views which would otherwise involve lots of tedious keystrokes.  The only
problem with the rails scaffold generator is that you need to know your database 
schema up front and then type lots of column_name:column_type arguments to the
generator to create the database migrations and the views with elements for all the
fields.

This project does much the same thing only the emphasis is on generating application
artifacts using a database schema as the source of information about columns and their types
and it also generates artifacts for an AngularJS Single Page Application.

Once you have generated the artifacts for your application you can then build your app 
using the generated artifacts as a base.  A lot of the donkey work has been done for you. 

## Dependencies

- Mysql2 or JDBC-Mysql connector
- Rake
- Erubis
- AngularUI (for datepicker)
- Restangular (and underscore or lodash) if using RestAngularBuilder

## Installation

git clone https://github.com/damianham/builder.git

## Usage

### Step 1  - generate the column info schema file from the database
```
 rake -f builder/tasks/mysql2.rake build_schema[testdb,testuser,testpass]    
```

Generates a testdb_column_info.yml file from the testdb database schema 
using a username of testuser and password of testpass 
using the mysql2 gem.  Use jdbc_mysql.rake if using JRuby.  To get the 
best results the tables in the database should define foreign key constraints 
and use table and column comments throughout.  For example for MySQL we can 
create a set of related tables with

```
create table `users` (
  `id` int(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `username` varchar(32) NOT NULL COMMENT 'The user identity used to login to the system',
  `password` varchar(64) NOT NULL COMMENT 'MD5 digest of the users password',
  `secret` varchar(255) NOT NULL COMMENT 'The users answer to the secret question for account recovery', 
  `updated_at` TIMESTAMP COMMENT 'Rails convention - date time the record was last updated',
  `created_at` DATETIME COMMENT 'Rails convention - date time the record was initially created'
) COMMENT 'Users are people who can login to the system and create interesting posts and witty comments';

create table `posts` (
  `id` int(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `title` varchar(255) NOT NULL COMMENT 'The title of the post that will appear in lists, tables and headings',
  `content` text NOT NULL COMMENT 'The main body content of the post',
  `user_id` int(10) NOT NULL COMMENT 'Foreign key to the user record in the users table that created the post',
  `updated_at` TIMESTAMP COMMENT 'Rails convention - date time the record was last updated',
  `created_at` DATETIME COMMENT 'Rails convention - date time the record was initially created',
  KEY `posts_user_id` (`user_id`),
  CONSTRAINT `posts_user_id_fk` FOREIGN KEY (`user_id`) REFERENCES `users`(`id`)
) COMMENT 'Posts are created by users and contain really interesting information';

create table `comments` ( 
  `id` int(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `content` text NOT NULL COMMENT 'The main body content of the comment',
  `post_id` int(10) NOT NULL COMMENT 'Foreign key to the post record in the posts table the comment relates to',
  `user_id` int(10) NOT NULL COMMENT 'Foreign key to the user record in the users table that created the comment',
  `updated_at` TIMESTAMP COMMENT 'Rails convention - date time the record was last updated',
  `created_at` DATETIME COMMENT 'Rails convention - date time the record was initially created',
  KEY `comments_post_id` (`post_id`),
  KEY `comments_user_id` (`user_id`),
  CONSTRAINT `comments_post_id_fk` FOREIGN KEY (`post_id`) REFERENCES `posts`(`id`)
  CONSTRAINT `comments_user_id_fk` FOREIGN KEY (`user_id`) REFERENCES `users`(`id`)
) COMMENT 'Comments completely trash the contents of posts - or maybe not';

```

### Step 2 - create any other application structures using other generators

For example you may want to create a Ruby on Rails application using the rails application generator

```
rails new mywebapp
```

### Step 3 - Configure the builder

Copy builder_config.rb to the current working directory and edit the copied 
file to define the generators and their output folders. 

The builders are defined in a hash with the name of the builder as the key and the 
builder options, including the output folder, as the value.  The default
builders are

* RailsBuilder
* AngularRailsBuilder

Other generators available are 

* RSpecBuilder 
* RailsVanillaBuilder (use instead of RailsBuilder to use rails scaffold generator)
* RestAngularBuilder  (use instead of AngularRailsBuilder)
* RestAngularModalBuilder  (use instead of RestAngularBuilder)

The RailsBuilder generates controllers,models and views and the AngularRailsBuilder
generates Angular service factories, controllers and view partials.  
If you want to use the scaffold generator that ships with Rails then change 
RailsBuilder to RailsVanillaBuilder however note that the models generated by 
the Rails scaffold generator will not have the **has_many** and **belongs_to** 
method calls to define the class relationships, nor will it have the validation 
method calls for required columns.

For example if you created a new rails application using the rails application 
generator as described above and you have 
a directory structure like


> workspace

> > builder

> > mywebapp

> > builder_config.rb 


then you would set the output folders to the following values

```
#### define the output destinations relative to where you run the rake command

@builders = {
  RailsBuilder => {:output => './mywebapp'  },
  AngularRailsBuilder => {:output => './mywebapp' }
}
```

and run the rake commands in the workspace directory with the builder_config.rb 
file in the workspace directory.

You can also add :only and :except elements to each builder's options hash 
which are both arrays of method name symbols to limit the actions of each builder.

If the :only option exists then only methods named in the 
:only array will do anything, all other methods will return immediately.  Any 
methods named in the :except array will do nothing and return immediately.

You can also add the appname option e.g. :appname => 'myapp' for the 
Angular module name.  This is the name of the Angular application and is given as the
ng-app name in the html start tag.  The default Angular module name is 'mainapp'.

Our example config file now looks like this.

```
#### define the output destinations relative to where you run the rake command

@builders = {
  RailsBuilder => {:output => './myapp',:appname => 'myapp' ,
  # do not do anything for these methods
  :except => [:finalize_menu ] },

  AngularRailsBuilder => {:output => './myapp',:appname => 'myapp',
  # don't generate the 'app/assets/javascripts/generated/app/app.js' artifact
  :except => [:finalize_application]}
}
```

It is quite probable that you want to generate an Angular front end 
that uses a backend api service for data that is namespaced e.g. 

    /api_v1/users/


You can give an *api_prefix* option to the Angular builders rather than a
namespace in order to access the api at the given path.

Our example config file now looks like this.

```
#### define the output destinations relative to where you run the rake command

@builders = {
  RailsBuilder => {:output => './myapp',:appname => 'myapp' ,
  :namespace => 'api_v1', 
  :except => [:finalize_menu] },

  AngularRailsBuilder => {:output => './myapp',:appname => 'myapp',
  :api_prefix => 'api_v1',
  :except => [:finalize_application]}
}
```

#### define the fields to use for each kind of template for each table

When generating the detail.html, form.html and list.html files for each
table/module limit the fields that are generated to the given list.  
RSpecBuilder also uses these lists to generate attributes for testing views.  
Any column name listed in :except is removed from all tables.

```
@fields = {
  :except => [:id,:created_at,:updated_at],
  :detail => {
    :users => [:email,:name,:gender,:birthday]  
  },
  :form => {
    :users => [:email,:name,:gender,:birthday]
  },
  :list => {
    :users => [:email,:name,:gender,:birthday],
    :places => [:name, :lat,:long,:map_link]
    }
}
```


#### define any tables to ignore
```
IGNORE_TABLES = ['dodgy_table1','dummy_table2']
```

Do not generate artifacts for dodgy_table1 and dummy_table2. The Rails migration
version table **schema_migrations** is ignored by the column info generator tasks.

#### Edit builder/lib/angular_rails.rb

define the type of list template to use - either 'list', or 'table'
```
# define to 'list' to use the list template 
# or 'table' to use the table template
  LIST_TYPE = 'table'
```  

Uses the builder/templates/ng/partial-table.erb template to produce the 
list.html for each class.

### Step 4  - customize the view templates in the templates folder to your liking

Edit builder/templates/(ng|rails|restangular)/*.erb.  These templates are used to generate
the artifacts.  Note that if you are using the AngularRails builder then the templates
that are used are in the folder **templates/ng**.   If you use the RestAngular builder
instead then the templates used are in the folder **templates/restangular**.

Some form fields need special rendering. For example a date field could be 
rendered with a date picker rather than as a text field.
The AngularUI team provide a set of Bootstrap components written in pure 
AngularJS that includes a date picker.  

You can download the ui.bootstrap library from http://angular-ui.github.io/bootstrap/

For a given model,name,column type you can create field partials that will be used to render
the field with the following order of priority

*  model_name.column_name
*  model_name.column_type
*  column_name
*  column_type

so for a column name of birthday with a field type of date in the user model
e.g.
```
create table users (
  birthday date
);
```
The Angular partial-form view will look for a partial to render for the field in the following order

* templates/ng/field_partials/models/user/_birthday.erb
* templates/ng/field_partials/models/user/_date.erb
* templates/ng/field_partials/by_name/_birthday.erb
* templates/ng/field_partials/by_type/_date.erb

If none of these files exist then the file

templates/ng/field_partials/_any_field.erb 

is used to render the field.

At the moment this only works for Angular Form views.

### Step 5  - generate the application artifacts

```
rake -f builder/tasks/builder.rake build_classes[testdb[,namespace]]
```

generates the application artifacts in the output folder using the 
generated testdb_column_info.yml file as input.  The namespace argument will 
place the artifacts in a subfolder with that namespace.  If no appname is 
supplied in the builder options then the Angular module name will adopt 
the namespace argument.  You can also define a different 
namespace for each different builder by adding the namespace to the builder options. 
E.g. 

```
@builders = {
  RailsBuilder => {:output => './myapp',:appname => 'myapp' ,
  :namespace => 'api',  # place the rails artifacts in the 'api' namespace
  # do not do anything for these methods
  :except => [:finalize_menu, :build_model, :build_controller] },

  AngularRailsBuilder => {:output => './myapp',:appname => 'myapp',
  # don't do anything except finalize the menu
  :only => [:build_model, :build_controller]}
}
```

The footer,header,home,menu partials from builder/templates/ng/footer.html.erb 
etc. will be generated in mywebapp/public/generated/partials.

The main angular module app.js will be generated in 
mywebapp/app/assets/javascripts/generated/app along with the services.js module.

An Angular module with a service factory and controllers for the detail,form 
and list views will be generated from builder/templates/ng/module.js.erb 
in mywebapp/app/assets/javascripts/generated/modules for each database table.  
Routes to the standard CRUD actions (list,detail,new,show) will be added to the module.

The usual Angular way is to generate a controllers in controller.js, services 
in services.js etc.  This approach collects related elements together so the 
User service factory is in the same place as the UserList and UserForm controller etc.

Html view files for the detail,form and list views for each database table 
will be generated from builder/templates/ng/partial-detail.erb etc. in 
mywebapp/public/generated/views/__table_name__/.  

Either builder/templates/ng/partial-table.erb or
builder/templates/ng/partial-list.erb will be used to generate the list.html file
depending on the value of LIST_TYPE in builder/lib/angular_rails.rb


You can also pass the location of the config file and column info file as 
environment variables to the rake task

```
rake -f builder/tasks/builder.rake conf='path_to_config_file' columns='path_to_column_info_file'  build_classes
```

in which case there is no need to pass the database name as an argument.  
Note that if you want to pass a namespace argument then you must also provide 
the database name first as in **build_classes[testdb,api]**  where api is the 
namespace.


### Step 6  - integrate angular into your rails web application

Integrate the Angular app into your web application by adding the ng-app
attribute to the html opening tag of mywebapp/app/views/layouts/application.html.erb 
using either the appname option 
from the AngularRailsBuilder config, the namespace option to build_classes 
or the default 'mainapp'.

```
<html lang="en" ng-app='mywebapp'>
<head>
        
        <% 
        # add angular-touch.min.js for mobiles
        # load jquery from googleapis CDN - also remove it from application.js
        { "https://ajax.googleapis.com/ajax/libs/jquery/2.1.3/" => [ "jquery.min.js"],
          "http://ajax.googleapis.com/ajax/libs/angularjs/1.3.7/" => 
            ['angular.min.js','angular-animate.min.js','angular-cookies.min.js',
          'angular-resource.min.js','angular-cookies.min.js','angular-loader.min.js',
          'angular-messages.min.js',
          'angular-sanitize.min.js','angular-route.min.js'],
          "http://cdnjs.cloudflare.com/ajax/libs/restangular/1.3.1/" => ['restangular.min.js'],
          "http://cdn.jsdelivr.net/underscorejs/1.7.0/" => ["underscore-min.js"],
          "http://netdna.bootstrapcdn.com/bootstrap/3.2.0/js/" => ["bootstrap.min.js"]
          }.each_pair do |cdn,list|
            list.each do |lib| %>
              <% if Rails.env.production?  %>
                <script src="<%= cdn + lib %>"></script>
              <% else %>
                <script src="/javascript/<%= lib %>"></script> 
              <% end %>
            <% end 
          end
        %>

        <%= stylesheet_link_tag    'application', media: 'all', 'data-turbolinks-track' => true %>
        <%= javascript_include_tag 'application', 'data-turbolinks-track' => true %>
        <%= csrf_meta_tags %>

</head>
<body>
    <!-- the angular view -->
    <div ng-view></div>
</body>
</html>
```

Add the angular main module and the modules folder to 
app/assets/javascrips/application.js
```
//= require jquery
//= require jquery_ujs
//= require turbolinks 

//= require app/app
//= require app/services
//= require_tree ./modules
```

##  Complete run through

The following steps will create application artifacts from scratch based on
a mysql database existing called testdb and a database user with the logon 
username:password credentials of testuser:testpass

```
# we don't want everything in the home folder so let's use Eclipse convention
cd ~/workspace  
git clone https://github.com/damianham/builder.git
rake -f builder/tasks/mysql2.rake build_schema[testdb,testuser,testpass]
rails new mywebapp
cp builder/builder_config.rb .
edit builder_config.rb
edit builder/lib/angular_rails.rb
rake -f builder/tasks/builder.rake build_classes[testdb]
edit mywebapp/app/views/layouts/application.html.erb
edit mywebapp/app/assets/javascripts/application.js
```


##  TODO

- So many things
- Create Cucumber, CoffeeScript and Node.js generators
- Create schema extractors for other database engines

please fork and contribute

