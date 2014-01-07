require 'spec_helper'

describe Cart do
  before(){ Product.acts_as_cartable }
  it {should have_many :cart_items}
  it {should belong_to :shopper }
  
  describe "removing carts" do
    let(:cartable) {FactoryGirl.create(:product)}
    before do 
      Cart.destroy_all
      @one_day_old = FactoryGirl.create(:cart, :updated_at => Time.now - 2.day)
      @one_week_old = FactoryGirl.create(:cart, :updated_at => Time.now - 8.days)
      @cart_item_one = FactoryGirl.create(:cart_item, :cart_id => @one_day_old.id)
    end
    
    it "should remove carts a week old" do
      d = (Time.now.midnight - 7.to_i.days)
      scoped_carts = mock("carts")
      scoped_carts.should_receive(:find_in_batches)
      scoped_carts.should_receive(:expired).with(d).and_return(scoped_carts)
      Cart.should_receive(:with_state).with(:active).and_return(scoped_carts)
      Cart.remove_carts
    end
    
    it "should remove carts a 2 days old" do
      d = (Time.now.midnight - 2.to_i.days)
      scoped_carts = mock("carts")
      scoped_carts.should_receive(:find_in_batches)
      scoped_carts.should_receive(:expired).with(d).and_return(scoped_carts)
      Cart.should_receive(:with_state).with(:active).and_return(scoped_carts)
      Cart.remove_carts(2)
    end
    
    it "should delete the carts over a week old" do
      proc{ Cart.remove_carts() }.should change(Cart, :count).by(-1)
    end
    
    it "should delete the carts over a day old" do
      proc{ Cart.remove_carts(1) }.should change(Cart, :count).by(-2)
    end
    
    it "should not delete the any carts when not old enough" do
      proc{ Cart.remove_carts(14) }.should_not change(Cart, :count)
    end
    
    it "should return the number of deleted carts" do
      Cart.remove_carts(1).should == 2
    end
    
    it "should remove carts with another state" do
      d = (Time.now.midnight - 2.to_i.days)
      scoped_carts = mock("carts")
      scoped_carts.should_receive(:find_in_batches)
      scoped_carts.should_receive(:expired).with(d).and_return(scoped_carts)
      Cart.should_receive(:with_state).with(:failed).and_return(scoped_carts)
      Cart.remove_carts(2, :failed)
    end
  end
  
  describe "adding to a cart" do
    let(:cart) {FactoryGirl.create(:cart)}
    let(:cartable) {FactoryGirl.create(:product)}
    
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