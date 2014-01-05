class CartItemsController < ApplicationController
  
  before_filter :find_cart_item, :only => [:update, :destroy]
  
  def create
    persist_cart if @cart.new_record?
    @cart.add_item(find_cartable)
  end
  
  def update
    if @cart_item.update_attributes(cart_item_params)
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

  private

    def cart_item_params
      params.require(:cart_item).permit!
    end
    
end