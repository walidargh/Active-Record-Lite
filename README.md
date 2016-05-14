#Overview
NAME is an Active Record inspired ORM, that allows users to connect Ruby defined classes to SQL relational databases. 

#Base Class
Users can implement the functionality of NAME by having their defined classes inherit from the base class ``SQLObject``. By utilizing naming conventions (both in the class definitions and in the SQL table foreign keys) they will be able to establish associations betweeen relational databases.

The base class, ``SQLObject`` is implemented using metaprogramming concepts to create ``attr_accessor``'s for user database columns. These allow users to query their SQL databases using object method calls. Refer to the bottom table for the naming conventions that are implemented.

##Searchable
Users can use hash mapping relations to make SQL WHERE queries using a params hash ``{column_name: where_condition}`` (add example).         
META PROGRAMINING 
    The Searchable module allows users to apply query the database using typical 
## Associatable
Users are able to generate methods to access data from a relational database by providing foreign, primary keys, and the class name of associated to the table. Users can manually provide this information and define the method name, however if they utilize the naming conventions these relations are automatically established. (put make a table of with names and with out)
### BelongsTo
Users can create ``belongs_to`` associations between tables. This generates a method that generates an instance method to quickly query a related table, where it is relation is established through a foreign key. Calling the generated method returns a an instance of the class associated with the query result. 
### HasMany
The inverse relation to a ``belongs_to`` association is a ``has_many``. This generates an instance method that allows an instance method to quickly query a related table who's primary key appears as a foreign key in its database. Calling the generated method returns the query result as an array of class instances. 
### HasOneThrough
The ``has_one_through`` creates a one-to-one relation with another table. It generates an instance method that to quickly query a related table. The relation is established through a foreign key that is in the table associated with the class calling ``has_one_through``.

## Naming Conventions
