require 'state_machine'
module Carter
  module StateMachine
    module Cart
      def self.included(base)
        base.extend ClassMethods
        base.init_states        
      end
      
      module ClassMethods
        def init_states
          state_machine :state, :initial => :active do
            state :active, :processing, :failure, :success, :expired
            
            event :checkout do 
              transition [:active, :failure] => :processing
            end
          
            event :succeeded do
              transition :processing => :success
            end
          
            event :failed do
              transition :processing => :failure
            end
          
            event :expire do
              transition :active => :expired
            end
            
            after_transition :on => :succeeded, :do => :on_success # gateway says yes - to what is needed to add the products to the buyer.
            
            # +checkout hook+ - probably goes off to payment gateway.
            # expects another transition to be made in here to continue the cart lifecycle
            # possible actions are `cart.failed`, `cart.succeeded` for now that should do it.
            after_transition :on => :checkout, :do => :on_checkout 
            after_transition :on => :failed, :do => :on_failed
          end
        end
      end
    end
    
    module CartItem
      def self.included(base)
        base.extend ClassMethods
        base.send(:include, InstanceMethods)
        base.init_states        
      end
      
      module ClassMethods
        def init_states
          
          state_machine :state, :initial => :in_cart do
            state :in_cart, :processing, :failure, :purchased
            event :add_to_owner do 
              transition [:in_cart] => :processing
            end
          
            event :succeeded do
              transition :processing => :purchased
            end
          
            event :failed do
              transition :processing => :failure
            end
            
            after_transition :on => :add_to_owner, :do => :on_purchase
          end
        end
      end
      
      module InstanceMethods        
        def on_purchase
          self.cartable.send(self.cartable.after_purchase_method, self) if self.cartable.after_purchase_method
        end
      end
      
    end
  end
end