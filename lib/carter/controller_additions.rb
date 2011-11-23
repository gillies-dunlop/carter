module Carter

  # This module is automatically included into all controllers.

  module ControllerAdditions
    module ClassMethods
      
      def has_cart(*args)
        has_cart_options = args.extract_options!
        before_filter :load_cart, has_cart_options.slice(:only, :except)
        include InstanceMethods
      end

      def has_cart_for_checkout(*args)
        before_filter :load_cart_for_checkout, args.extract_options!.slice(:only, :except)
        include InstanceMethods
      end

    end

    def self.included(base)
      base.extend ClassMethods
      base.class_attribute :checking_out
      base.class_attribute :shopping
      base.class_attribute :has_cart_options
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
        session[:continue_shopping_url] || default
      end
      
      # to stop the has_cart method called from super class from setting the continue_shopping_url when checking out.
      def checking_out?
        checking_out == true
      end
      
      def shopping?
        shopping == true
      end
      

      def load_cart
        store_shopping_location if self.shopping? && !self.checking_out?
        @cart = load_cart_instance
        @shopper = current_shopper
      end

      def load_cart_for_checkout
        @cart = load_cart_instance
        @shopper = current_shopper
      end

      private

      def load_cart_instance
        find_cart_by_session || find_cart_by_shopper  || ::Cart.new
      end


      def find_cart_by_shopper
        ::Cart.with_state(default_cart_state).first(:conditions => {:shopper_id => current_shopper.id, :shopper_type => current_shopper.class.name} ) if current_shopper && Carter.settings.persist_by_shopper?
      end

      def find_cart_by_session
        ::Cart.with_state(default_cart_state).find_by_id(session[:cart_id]) 
      end

      def current_shopper
        self.respond_to?(:current_user) ? self.send(:current_user) : nil
      end

      def store_shopping_location
        session[:continue_shopping_url] = self.request.fullpath 
      end

      def name_from_carter_controller
        params[:controller].sub("Controller", "").underscore.split('/').last.singularize
      end

      def default_cart_state
        :active
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
