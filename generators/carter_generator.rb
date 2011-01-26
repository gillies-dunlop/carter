class CarterGenerator < Rails::Generator::Base
  default_options :skip_migration => false
  
  def manifest
    record do |m|
      if !options[:skip_migration] && defined?(ActiveRecord)
        m.migration_template "migration.rb", 'db/migrate',
                             :migration_file_name => "create_carter"
      end
    end
  end
  
protected

  def add_options!(opt)
    opt.separator ''
    opt.separator 'Options:'
    opt.on("--skip-migration", "Don't generate a migration") { |v| options[:skip_migration] = v }
  end
  
end
