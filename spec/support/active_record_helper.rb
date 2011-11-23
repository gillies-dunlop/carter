
require 'active_record'
ActiveRecord::Base.extend Carter::ActiveRecord::Cartable if defined?(ActiveRecord)

Dir["app/models/*.rb"].each {|f| require f}

class User < ActiveRecord::Base
end

class Product < ActiveRecord::Base
  
end
class Thing < ActiveRecord::Base
  
end
def load_schema

  config = YAML::load(IO.read(File.dirname(__FILE__) + '/database.yml'))
  # ActiveRecord::Base.logger = Logger.new(File.dirname(__FILE__) + "/debug.log")

  db_adapter = ENV['DB']
 
  # no db passed, try one of these fine config-free DBs before bombing.
  db_adapter ||=
    begin
      require 'sqlite'
      'sqlite'
    rescue MissingSourceFile
      begin
        require 'sqlite3'
        'sqlite3'
      rescue MissingSourceFile
      end
    end
 
  if db_adapter.nil?
    raise "No DB Adapter selected. Pass the DB= option to pick one, or install Sqlite or Sqlite3."
  end
  

  ActiveRecord::Base.establish_connection(config[db_adapter])
  ActiveRecord::Schema.define(:version => 0) do
    create_table "users", :force => true do |t|
      t.string :name
      t.timestamps
    end
    create_table "things", :force => true do |t|
      t.string :name
      t.float :price
      t.timestamps
    end
    create_table "products", :force => true do |t|
      t.string :name
      t.float :price
      t.timestamps
    end

    create_table "cart_items", :force => true do |t|
      t.string :name
      t.string :state
      t.belongs_to :owner, :polymorphic => true
      t.belongs_to :cartable, :polymorphic => true
      t.belongs_to :cart
      t.column :price, :float 
      t.column :quantity, :integer
      t.timestamps
    end

    create_table "carts", :force => true do |t|
      t.string :session_id
      t.string :state
      t.belongs_to :shopper, :polymorphic => true
      t.timestamps
    end
  end

  
end

