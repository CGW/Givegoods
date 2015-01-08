if defined?(RSpec)

  # Clear the default actions. Doing so does not delete prerequisites.
  Rake::Task['spec'].instance_variable_set(:'@actions', [])

  # Run request specs independently of the other specs to avoid configuration
  # collisions.
  task :spec do
    Rake::Task['spec:all'].invoke
    Rake::Task['spec:requests'].invoke
  end

  namespace :spec do
    desc "Run all specs in spec directory (excluding requests specs)"
    RSpec::Core::RakeTask.new(:all => 'db:test:prepare') do |t|
      t.pattern = [:models, :controllers, :views, :helpers, :mailers, :lib, :routing].collect do |sub|
        "./spec/#{sub}/**/*_spec.rb"
      end
    end
  end
end
