bin/rails data:conv:html[src_file,output_dir]              # convert single html file
bin/rails data:conv:html:all[src_dir,output_dir]           # convert all html files
bin/rails data:conv:html_pi_l[src_file,output_dir]         # convert single html file with path_index and bookmark output
bin/rails data:conv:html_pi_l:all[src_dir,output_dir]      # convert all html and path_index and bookmark files
bin/rails data:conv_reg:html_pi_l:all[src_dir,output_dir]  # convert all html files and register path_index and bookmark into database
bin/rails data:install:pyvenv                              # install pyvenv
bin/rails data:register:pi_l[pi_file,l_file]               # register path_index and bookmark files into database
bin/rails data:size_bk                                     # Bookmark.all.size
bin/rails data:size_hierx                                  # Hierx.all.size
bin/rails data:size_pathx                                  # Pathx.all.size
bin/rails data:size_user                                   # User.all.size
bin/rails data:test                                        # test
bin/rails db:create                                        # Create the database from DATABASE_URL or config/database.yml for the current RAILS_ENV (use db:create:all to create...
bin/rails db:drop                                          # Drop the database from DATABASE_URL or config/database.yml for the current RAILS_ENV (use db:drop:all to drop all d...
bin/rails db:encryption:init                               # Generate a set of keys for configuring Active Record encryption in a given environment
bin/rails db:environment:set                               # Set the environment value for the database
bin/rails db:fixtures:load                                 # Load fixtures into the current environment's database
bin/rails db:migrate                                       # Migrate the database (options: VERSION=x, VERBOSE=false, SCOPE=blog)
bin/rails db:migrate:down                                  # Run the "down" for a given migration VERSION
bin/rails db:migrate:redo                                  # Roll back the database one migration and re-migrate up (options: STEP=x, VERSION=x)
bin/rails db:migrate:reset                                 # Resets your database using your migrations for the current environment
bin/rails db:migrate:status                                # Display status of migrations
bin/rails db:migrate:up                                    # Run the "up" for a given migration VERSION
bin/rails db:prepare                                       # Run setup if database does not exist, or run migrations if it does
bin/rails db:reset                                         # Drop and recreate all databases from their schema for the current environment and load the seeds
bin/rails db:rollback                                      # Roll the schema back to the previous version (specify steps w/ STEP=n)
bin/rails db:schema:cache:clear                            # Clear a db/schema_cache.yml file
bin/rails db:schema:cache:dump                             # Create a db/schema_cache.yml file
bin/rails db:schema:dump                                   # Create a database schema file (either db/schema.rb or db/structure.sql, depending on `ENV['SCHEMA_FORMAT']` or `con...
bin/rails db:schema:load                                   # Load a database schema file (either db/schema.rb or db/structure.sql, depending on `ENV['SCHEMA_FORMAT']` or `confi...
bin/rails db:seed                                          # Load the seed data from db/seeds.rb
bin/rails db:seed:replant                                  # Truncate tables of each database for current environment and load the seeds
bin/rails db:setup                                         # Create all databases, load all schemas, and initialize with the seed data (use db:reset to also drop all databases ...
bin/rails db:version                                       # Retrieve the current schema version number
