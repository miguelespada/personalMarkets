personal-markets
================

- Ruby 2.0.0
- mongodb
- elasticsearch

##Installation
Install elasticsearch: <code>brew install elasticsearch </code>

run <code>elasticsearch</code> to start search engine.

Install bundler: <code>gem install bundler</code>

cd into project directory and run <code>bundle install</code>

run <code>rails s</code> to start the application

##Load Database example

<code>mongorestore db/example_data.json/</code>

##Dump Database example

<code>mongodump -d pop_up_stores_development -o db/example_data.json</code>

##Database seeds
To seed the database with example data:

<code>rake db:seed</code>

To drop the database:

<code>rake db:purge</code>
