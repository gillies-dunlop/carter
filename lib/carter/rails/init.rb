if defined?(Rails)
  ActiveRecord::Base.extend Carter::ActiveRecord::Cartable if defined?(ActiveRecord)
  if Rails::VERSION::MAJOR == 3
    require 'carter/engine'
  else
    require 'carter/routing'
    ActionController::Routing::RouteSet::Mapper.send :include, Carter::Routing::MapperExtensions 
  end 
end

