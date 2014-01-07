require 'spec_helper'

describe Carter::ActiveRecord::Cartable do
  
  describe "configuration" do
    it "should add the thing class to the Carter config" do
      Thing.acts_as_cartable
      Carter.settings.cartables.should include(Thing.name)
    end
  end
  
  let(:cartable){FactoryGirl.create(:product)}
  it "should load the schema for testing" do
    Product.all.should be_a ActiveRecord::Relation
  end
 
  it "should add acts_as_cartable method to product" do
    Product.should respond_to(:acts_as_cartable)
  end
  
  describe "Product.acts_as_cartable" do
    context "default settings" do
      before(){ Product.acts_as_cartable }
     
      it "should add the product class to the Carter config" do
        Carter.settings.cartables.should include(Product.name)
      end
     
      it {cartable.should have_many(:cart_items)}
      it {cartable.should have_many(:carts) }
      it "should set the default name column" do
        Product.cartable_configuration[:name].should == "name"
      end
   
      it "should set the default price column" do
        Product.cartable_configuration[:price].should == "price"
      end
     
      it "should return the price" do
        cartable.price.should == cartable.cartable_price
      end
      it "should return the name" do
        cartable.name.should == cartable.cartable_name
      end
    end
   
    context "finding carts on a cartable" do
      let(:cart){ FactoryGirl.create(:cart) }
      let(:thing){ FactoryGirl.create(:thing) }
      before do
        cart.add_item(cartable, 2)
        cart.add_item(thing)
      end
     
      it 'should find the cart from the cartable' do
        cartable.carts.should be_include(cart)
        thing.carts.should be_include(cart)
      end
     
      it "a cartable should be in cart" do
        cartable.in_cart?(cart).should be_true
      end
    end
   
    context "custom settings" do
      before(){ Product.acts_as_cartable(:name => "ping", :price => "pong") }
     
      it "should set the name column" do
        Product.cartable_configuration[:name].should == "ping"
      end
   
      it "should set the price column" do
        Product.cartable_configuration[:price].should == "pong"
      end
    end
   
    describe "unique cart_items" do
      let(:cart){ FactoryGirl.create(:cart) }
      let(:product){ FactoryGirl.create(:product) }
      let(:thing){ FactoryGirl.create(:thing) }
      let(:owner) { FactoryGirl.create(:user) }
     
      before() do
        Product.acts_as_cartable(:unique => true)
        Thing.acts_as_cartable(:unique => true)
      end
     
      it "should not allow multiple cart_items in the cart of this cartable" do
        cartable.allow_multiples?.should be_false
      end
     
      it "should raise an error if an item of the same type is added to the cart" do
        cart.add_item(product)
        cart.cart_items.size.should == 1
        lambda{ cart.add_item(product) }.should raise_error(Carter::MultipleCartItemsNotAllowed, /is already in your basket/)
      end
     
      it "should not raise an error if an item of same type is added to the cart but with a different owner" do
        cart.add_item(product)
        cart.cart_items.size.should == 1
        lambda{ cart.add_item(product, 1, owner) }.should_not raise_error(Carter::MultipleCartItemsNotAllowed, /is already in your basket/)
        cart.cart_items.size.should == 2
      end
     
      it "should not raise an error if an item of different type is added to the cart" do
        cart.add_item(product)
        cart.cart_items.size.should == 1
        lambda{ cart.add_item(thing) }.should_not raise_error(Carter::MultipleCartItemsNotAllowed, /is already in your basket/)
        cart.cart_items.size.should == 2
      end
    end
  end
end
