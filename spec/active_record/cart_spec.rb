require 'spec_helper'

describe Cart do
  before(){ Product.acts_as_cartable }
  it {should have_many :cart_items}
  it {should belong_to :shopper }
  
  describe "adding to a cart" do
    let(:cart) {Factory(:cart)}
    let(:cartable) {Factory(:product)}
    
    it "should respond to add_item" do
      cart.should respond_to :add_item
    end
    
    it "should respond to empty?" do
      cart.should respond_to :empty?
    end
    
    it "should be empty" do
      cart.should be_empty
    end
    
    it "should increment cart items by one" do
      proc{ cart.add_item(cartable) }.should change(cart.cart_items, :size).by(1)
    end
    
    describe "cart totals" do
      before do
        cart.add_item(cartable, 2)
      end
      
      it "should not be empty" do
        cart.should_not be_empty
      end
      
      it "should return the total price of the cart" do
        cart.total.should == (2 * cartable.price)
        cart.add_item(cartable)
        cart.total.should == (3 * cartable.price)
      end
      
      # it "should have many cartables" do
      #   cart.cartables.should include(cartable)
      # end
      
      # it "should have many products" do
      #   cart.should respond_to(:products)
      # end
    end
    
  end
end