describe Carter::StateMachine::Cart do

  let(:cart){Factory(:cart) }
  let(:product){ Factory(:product) }
  
  describe "the states" do
    [:active, :processing, :failure, :success, :expired].each do |state|
      it "should have the state #{state}" do
        cart.should respond_to("#{state}?")
      end
    end
  end
  
  describe "the transitions" do
    [:checkout, :succeeded, :failed, :expire].each do |transition|
      it "should have the transition event #{transition}" do
        cart.should respond_to("#{transition}")
      end
    end
  end
  
  describe "the lifecycle" do
    it "should have an initial state of active" do
      cart.active?.should be_true
    end
    
    describe "without a on_checkout proc defined" do
      it "should transition to straight to paid on checkout" do
        expect { cart.checkout }.to change(cart, :state).from("active").to("success")
      end
    end
    
    describe "with a on_checkout proc defined" do
      before(:each) do
        @gateway = mock()
        Carter::Config.on_checkout = Proc.new() do |record|
          if @gateway.status == :success
             record.succeeded
          else
             record.failed 
          end
        end
     end
      
      describe "a successful payment" do
        before(:each) do
          Product.acts_as_cartable :on_purchase => :yippee_shiny_product_is_mine 
          @gateway.should_receive(:status).and_return(:success)
        end
        
        it "should transition to paid on success " do
          expect { cart.checkout}.to change(cart, :state).from("active").to("success")
        end
        
        it "should trigger the on success method" do
          cart.should_receive(:on_success)
          cart.checkout
        end
        
        context "with cart_items" do
          before(:each) do
            product.stub!(:yippee_shiny_product_is_mine)
          end

          it "should trigger the add_to_owner method for each cart_item" do
            cart.add_item(product)
            cart.cart_items.each{|cart_item| 
              cart_item.should_receive(:add_to_owner) 
            }
            cart.checkout
          end
        
          it "should call the on purchase method for the cartable product" do
            cart.add_item(product)
            cart.cart_items.each{|cart_item| 
              cart_item.stub!(:cartable).and_return(product) 
            }
            product.should_receive(:yippee_shiny_product_is_mine)
            cart.checkout
          end
        end
      end
      describe "a failed payment" do
        before(:each) do
          Product.acts_as_cartable :on_purchase => :yippee_shiny_product_is_mine 
          @gateway.should_receive(:status).and_return(:failed)
        end 
        
        it "should transition to failure on success " do
          expect { cart.checkout}.to change(cart, :state).from("active").to("failure")
        end
        
        it "should trigger the on_failure method" do
          cart.should_receive(:on_failed)
          cart.checkout
        end
      end
    end
  end
end