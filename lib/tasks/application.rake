# Monkeypatch to add more directories to search path. Rails unfortunately makes
# this difficult to configure, but patching is easy.
class SourceAnnotationExtractor
  alias __find find
  def find(dirs=%w(app lib test config))
    __find(dirs)
  end
end

task(:default).clear_prerequisites.clear_actions
task :default => "test:fast"

namespace :dev do
  desc "Set up dev environment"
  task :setup => ["db:setup", "db:fixtures:load"]
end

namespace :test do
  Rake::TestTask.new(:fast => ["test:prepare"]) do |t|
    t.libs << "test"
    t.pattern = 'test/{unit,functional,integration}/**/*_test.rb'
  end
  Rake::Task['test:fast'].comment = "Run all tests together"
end

namespace :db do
  desc "Destroys seeded instances"
  task :unseed => :environment do
    Merchant.destroy_all
    Charity.destroy_all
    AdminUser.destroy_all
  end

  namespace :extras do
    task :load => :environment do
      extras = File.read(Rails.root.join("db", "extras.sql"))
      ActiveRecord::Base.connection.execute extras
    end
  end

  namespace :functions do
    task :load => :environment do
      functions = File.read(Rails.root.join("db", "functions.sql"))
      ActiveRecord::Base.connection.execute functions
    end
  end

  namespace :schema do
    task :load do
      Rake::Task["db:extras:load"].invoke
      Rake::Task["db:functions:load"].invoke
    end
  end

  namespace :fixtures do
    task :extract => :environment do
      sql  = "SELECT * FROM %s"
      skip_tables = %w(schema_info schema_migrations)
      ActiveRecord::Base.establish_connection
      (ActiveRecord::Base.connection.tables - skip_tables).each do |table_name|
        i = "000"
        File.open("#{Rails.root}/test/fixtures/#{table_name}.yml", 'w') do |file|
          data = ActiveRecord::Base.connection.select_all(sql % table_name)
          file.write data.inject({}) {|hash, record|
            hash["#{table_name}_#{i.succ!}"] = record
            hash
          }.to_yaml
        end
      end
    end
  end
end
