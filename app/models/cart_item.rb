class CartItem < ActiveRecord::Base
  belongs_to :cart
  belongs_to :cartable, :polymorphic => true
  belongs_to :owner, :polymorphic => true
  delegate :shopper, :to => :cart
  
  extend Carter::ActiveRecord::Extensions
  include Carter::StateMachine::CartItem
  
  after_update :check_quantity
  
  # Match a cart_item by owner and cartable
  named_scope :for_cartable, lambda { |cartable|
    { :conditions => { :cartable_type => cartable.class.to_s, :cartable_id => cartable.id } }
  }
  
  named_scope :for_owner, lambda {|owner|
    { :conditions => { :owner_id => (owner ? owner.id : nil), :owner_type =>  (owner ? owner.class.to_s : nil) } }
  }
  
  named_scope :for_cartable_and_owner, lambda {|cartable, owner| 
    { :conditions => for_owner(owner).proxy_options[:conditions].merge!(for_cartable(cartable).proxy_options[:conditions])}
  }
   
  money_composed_column :total_price, 
    :mapping => [[:price, :cents], [:quantity]], 
    :constructor => Proc.new{|value, quantity| Money.new(value.to_i * quantity.to_i)}
  
  money_composed_column :price
  
  def refresh
    update_attributes :price => cartable.cartable_price, :name => cartable.cartable_name 
  end
  
  protected
  
  def check_quantity
    self.destroy if self.quantity < 1
  end
end
