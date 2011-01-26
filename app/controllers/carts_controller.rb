class CartsController < ApplicationController
  load_cart_and_cartable

  def show

  end
  
  def destroy
    cart.destroy
  end
end