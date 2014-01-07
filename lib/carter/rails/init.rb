if defined?(Rails)
  ActiveRecord::Base.extend Carter::ActiveRecord::Cartable if defined?(ActiveRecord)
  
  require 'carter/engine'
end

