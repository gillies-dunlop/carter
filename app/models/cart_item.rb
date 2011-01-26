class CartItem < ActiveRecord::Base
  belongs_to :cart
  belongs_to :cartable, :polymorphic => true
  belongs_to :owner, :polymorphic => true
  delegate :shopper, :to => :cart
  
  # validates_uniqueness_of :cart_id, :scope => [:cartable, :owner]
  
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
     
  composed_of :total_price,
              :class_name => 'Money',
              :mapping => %w(price cents),
              :converter => Proc.new { |value| value.respond_to?(:to_money) ? value.to_money : Money.empty }
  
  include Carter::StateMachine::CartItem
             
  def total_price
    (quantity * price.to_i)
  end
end
