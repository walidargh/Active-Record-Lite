#Overview
NAME is an Active Record inspired ORM, that allows users to connect Ruby defined classes to SQL relational databases. 

#Base Class
Users can implement the functionality of NAME by having their defined classes inherit from the base class ``SQLObject``. By utilizing naming conventions (both in the class definitions and in the SQL table foreign keys) they will be able to establish associations betweeen relational databases.

The base class, ``SQLObject`` is implemented using metaprogramming concepts to create ``attr_accerssor``'s for user database columns. These allow users to query their SQL databases using object method calls. Refer to the bottom table for the naming conventions that are implemented.

##Searchable
Users can use hash mapping relations to make SQL WHERE queries using a params hash {column_name: where_condition} (add picture).         
META PROGRAMINING 
    The Searchable module allows users to apply query the database using typical 

## Associatable


## Naming Conventions
