class CreateCarter < ActiveRecord::Migration
  def self.up
    create_table :carts do |t|
      t.string :session_id, :state
      t.belongs_to :shopper, :polymorphic => true
      t.timestamps
    end
    
    add_index :carts, :shopper_id
    add_index :carts, :state
    add_index :carts, :shopper_type
    
    create_table :cart_items do |t|
      t.string :name, :state
      t.belongs_to :cartable, :polymorphic => true
      t.belongs_to :owner, :polymorphic => true
      t.belongs_to :cart
      t.column :price, :float, :default => "0.00" 
      t.column :quantity, :integer
      t.timestamps
    end
    
    add_index :cart_items, :name
    add_index :cart_items, :state
    add_index :cart_items, :cartable_id
    add_index :cart_items, :cart_id
    add_index :cart_items, :cartable_type
    add_index :cart_items, :owner_id
    add_index :cart_items, :owner_type
  end

  def self.down
    drop_table :carts
    drop_table :cart_items
  end
end

