module Carter

  # This module is automatically included into all controllers.

  module ControllerAdditions
    module ClassMethods
      
      def has_cart(*args)
        ControllerResource.add_before_filter(self, :load_cart, *args)
        include InstanceMethods
      end

      def has_cart_for_checkout(*args)
        ControllerResource.add_before_filter(self, :load_cart_for_checkout, *args)
        include InstanceMethods
      end

    end

    def self.included(base)
      base.extend ClassMethods
      base.class_inheritable_accessor :checking_out
      base.class_inheritable_accessor :shopping
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
      
      def redirect_to_continue_shopping_or_default(default)
        redirect_to continue_shopping_or_default_url(default)
        session[:continue_shopping_url] = nil
      end
      
      def continue_shopping_or_default_url(default)
        session[:continue_shopping_url] || default || root_url
      end
      
      # to stop the has_cart method called from super class from setting the continue_shopping_url when checking out.
      def checking_out?
        checking_out == true
      end
      
      def shopping?
        shopping == true
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
