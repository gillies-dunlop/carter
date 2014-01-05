class CartsController < ApplicationController

  def show

  end
  
  def destroy
    cart.destroy
  end
end