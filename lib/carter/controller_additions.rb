module Carter

  # This module is automatically included into all controllers.

  module ControllerAdditions
    module ClassMethods

      def has_cart(*args)
        ControllerResource.add_before_filter(self, :load_cart, *args)
        include InstanceMethods
      end
      
      def load_cart_and_cartable(*args)
        ControllerResource.add_before_filter(self, :load_cart_and_cartable, *args)
      end

    end

    def self.included(base)
      base.extend ClassMethods
      base.helper_method :cart, :has_cart?, :shopper
    end
    
    module InstanceMethods
      def cart
        @cart
      end
      
      def shopper
        @shopper
      end
      
      def has_cart?
        !@cart.nil?
      end
      
      protected

      def find_cartable(cartable_id=params[:cartable_id])
        @cartable = cartable_class.find_by_id(cartable_id)
      end

      def cartable_class(cartable_type=params[:cartable_type])
        cartable_type.constantize
      end

      def add_cartable_to_cart(cartable, quantity = 1, owner = nil)
        persist_cart
        cart.add_item(cartable, quantity, owner)
      end
      
      def persist_cart
        cart.save
        session[:cart_id] = cart.id
      end
    end
  end
  
end

if defined? ActionController
  ActionController::Base.class_eval do
    include Carter::ControllerAdditions
  end
end
