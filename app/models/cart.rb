class Cart < ActiveRecord::Base
  belongs_to :shopper, :polymorphic => true # for extra persistance
  has_many :cart_items, :dependent => :destroy

  include Carter::Cart
  extend Carter::ActiveRecord::Extensions

  attr_accessor :gateway_response
  
  def add_item(cartable, quantity = 1, owner=nil)
    existing_cart_item = cart_item_for_cartable_and_owner(cartable, owner)
    Cart.transaction do
      if existing_cart_item.blank?
        cart_items.create!(:cartable => cartable, :name => cartable.cartable_name, :price => cartable.cartable_price, :quantity => quantity, :owner => owner)
      else
        if cartable.allow_multiples?
          existing_cart_item.update_attributes(:quantity => existing_cart_item.quantity + quantity)
        else
          raise Carter::MultipleCartItemsNotAllowed, "#{cartable.cartable_name} is already in your basket"
        end
      end
    end
  end
  
  # TODO cache this value
  def total
    cart_items.reload.map.sum(&:total_price).to_money
  end
  
  def empty?
    cart_items.blank?
  end
  
end
