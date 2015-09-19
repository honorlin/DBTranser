
#Use Active Reocrd to trans data fo DB to anthor DB

How to use?

1. Add active record gem of db you want  to Gemfile

2. run bundle

3. modify database,yml to any db you want

Example:

``` database,yml
source_db:
  adapter: mysql2
  encoding: utf8
  database: magazine
  username: root
  password: root
  pool: 5

destination_db: 
  adapter: postgresql
  encoding: unicode 
  database: 
  pool: 5
  username: 
  password: 
  host: 
  port: 5432
```

And then run it

# MySQL of Joomla to PostgreSQL

1. modify the model of the table to access the table
2. modify the column of table you want to fetch and migrate

run jommla_mysql_contents_to_postgresql.rb




