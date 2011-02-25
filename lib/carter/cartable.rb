module Carter
  module ActiveRecord #:nodoc:
    module Cartable #:nodoc:
      
      # Options
      #   acts_as_cartable :name => "name_column", :price => "price_column", :unique => true / false
      #   :unique => true # this allows only one item of this type in the cart.
      def acts_as_cartable(options = {})
        configuration = { :name => "name", :price => "price", :unique => false }
        configuration.update(options) if options.is_a?(Hash)
        @cartable_configuration = configuration
        has_many :cart_items, :as => :cartable
        has_many :carts, :through => :cart_items
        register_cartable(self)
        include InstanceMethods
        true
      end
      
      def cartable_configuration
        @cartable_configuration ||= {}
      end
      
      protected
      
      def register_cartable(klass)
        Carter.settings.cartables = (Carter.settings.cartables << klass.name).uniq
        # ::Cart.add_cart_association(klass)
      end
    end
    
    module InstanceMethods
    
      def cartable_price
        self.send(cartable_configuration_value_by_key(:price))
      end
      
      def cartable_name
        self.send(cartable_configuration_value_by_key(:name))
      end
      
      def in_cart?(cart, owner=nil)
        !cart.cart_item_for_cartable_and_owner(self, owner).nil?
      end
      
      def allow_multiples?
        !cartable_configuration_value_by_key(:unique)
      end
      
      def after_purchase_method
        cartable_configuration_value_by_key :after_purchase_method
      end
      
      private
      
      def cartable_configuration_value_by_key(key)
        self.class.cartable_configuration[key]
      end
    end
  end
end