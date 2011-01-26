class CartItemsController < ApplicationController
  load_cart_and_cartable
  before_filter :find_cart_item, :only => [:update, :destroy]
  
  # RESTful equiv of add
  def create
    persist_cart if @cart.new_record?
    @cart.add_item(find_cartable)
  end
  
  def update
    if @cart_item.update_attributes(params[:cart_item])
      flash[:notice] = t(:cart_updated)
      redirect_to cart_path(cart)
    else
      flash[:notice] = t(:cart_update_failed)
    end
  end
  
  def destroy
    if @cart_item.destroy
      flash[:notice] = t(:cart_item_removed)
      redirect_to cart_path(@cart)
    else
      flash[:notice] = t(:cart_update_failed)
    end
  end
  
  protected
  
  def find_cart_item
    @cart_item = @cart.cart_items.find(params[:id])
  end
end