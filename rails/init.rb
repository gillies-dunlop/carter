if defined?(Rails)
  require 'carter/engine' if Rails::VERSION::MAJOR == 3
  ActiveRecord::Base.extend Carter::ActiveRecord::Cartable if defined?(ActiveRecord)
  require 'carter/routing'
  ActionController::Routing::RouteSet::Mapper.send :include, Carter::Routing::MapperExtensions
end

