namespace :db do

  desc 'Truncate all tables except schema_migrations and import seeds'
  task :truncate => "db:load_config" do
      config = ActiveRecord::Base.configurations[::Rails.env]
      ActiveRecord::Base.establish_connection
      tables = ActiveRecord::Base.connection.tables - ['schema_migrations']
      print "Truncating tables (except schema_migrations), please wait"
      tables.each do |table|
        ActiveRecord::Base.connection.execute("TRUNCATE #{table}")
        print "."
      end
      print " [ \e[0;32m OK \e[0m ]"
      #print "\nSeeding tables, please wait..."
      #Rake::Task["db:seed"].invoke
      #print " [ \e[0;32m OK \e[0m ]\n"
      puts "Done."
    end
end
