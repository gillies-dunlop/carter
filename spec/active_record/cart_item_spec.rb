require 'spec_helper'

describe CartItem do
  before(){ Product.acts_as_cartable }
  it {should belong_to :cart}
  it {should belong_to :cartable }
  it {should belong_to :owner }

  describe "named scopes" do
    let(:owner_1) { Factory(:user) }
    let(:product_1){ Factory(:product) }
    let(:product_2){ Factory(:product) }
    let(:cart) { Factory(:cart) }
    
    before(:each){
      cart.add_item(product_1)
      cart.add_item(product_1, 1, owner_1)
      cart.add_item(product_2, 1, owner_1)
    }
    
    it "should find the cart_item by product and owner" do
      cart.cart_items.for_cartable_and_owner(product_2, owner_1).size.should == 1
      cart.cart_items.for_cartable_and_owner(product_2, owner_1).first.cartable.should == product_2
      cart.cart_items.for_cartable_and_owner(product_2, owner_1).first.owner.should == owner_1
    end
    
    it "should find the cart_item by product and owner is blank" do
      cart.cart_items.for_cartable_and_owner(product_2, nil).size.should == 0
      cart.cart_items.for_cartable_and_owner(product_1, nil).size.should == 1
      cart.cart_items.for_cartable_and_owner(product_1, nil).first.cartable.should == product_1
      cart.cart_items.for_cartable_and_owner(product_1, nil).first.owner.should == nil
    end
    
    it "should find the cart_items by product" do
      cart.cart_items.for_cartable(product_1).size.should == 2
      cart.cart_items.for_cartable(product_1).first.cartable.should == product_1
      cart.cart_items.for_cartable(product_1).last.cartable.should == product_1
    end
  end
  
  describe "an instance" do
    let(:cart){ Factory(:cart) }
    let(:cart_item) {Factory(:cart_item, :cart => cart ) }
    it "should respond to shopper" do
      cart_item.should respond_to :shopper
    end
    
    it "should delegate shopper to the cart" do
      cart_item.shopper.should == cart.shopper
    end
  end
  
  describe "adding to a cart" do
    let(:cart) {Factory(:cart)}
    let(:cartable) {Factory(:product)}

    it "should respond to add_item" do
      cart.should respond_to :add_item
    end
    
    it "should increment cart items by one" do
      proc{ cart.add_item(cartable) }.should change(cart.cart_items, :size).by(1)
    end
    
    it "should bump the quatity value of an exisitng item if the cart_item already exists" do
      cart.add_item(cartable)
      cart.cart_items.size.should == 1
      proc{ cart.add_item(cartable) }.should_not change(cart.cart_items, :size)
      cart.total.should == (cartable.price * 2)
    end
    
    it "should remove the item if the quantity is 0" do
      cart.add_item(cartable)
      cart_item = cart.cart_items.first
      lambda{ cart_item.update_attributes(:quantity => 0) }.should change(cart.cart_items, :size).from(1).to(0)
    end

    it "should remove the item if the quantity is less than zero" do
      cart.add_item(cartable)
      cart_item = cart.cart_items.first
      lambda{ cart_item.update_attributes(:quantity => -1) }.should change(cart.cart_items, :size).from(1).to(0)
    end
    
    describe "cart totals" do
      before do
        cart.add_item(cartable, 2)
      end
      
      it "should return the total price of the cart" do
        cart.total.should == (2 * cartable.price)
        cart.add_item(cartable)
        cart.total.should == (3 * cartable.price)
      end
    end
    
  end
end