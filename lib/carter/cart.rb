module Carter
  module Cart
    
    def self.included(base)
      base.send :include, InstanceMethods
      base.send :include, Carter::StateMachine::Cart
      base.extend ClassMethods

      base.class_eval do
        scope :expired, lambda { |expiry_date = Time.now| where("updated_at < ?", expiry_date) }
      end
    end
    
    module InstanceMethods
      def cartables
        Carter.settings.cartables.inject([]) do |result, cartable_type|
          result.concat self.send(cartable_type.downcase.pluralize)
          result
        end
      end
      
      def on_checkout
        if Carter.settings.on_checkout.is_a?(Proc)
          Carter.settings.on_checkout.call(self)
        end
      end
      
      # On success from checkout call the add event on each cart item.
      def on_success
        self.cart_items.each{|cart_item| cart_item.add_to_owner }
      end
      
      def on_failed
        if Carter.settings.on_failed.is_a?(Proc)
          Carter.settings.on_failed.call(self)
        end
      end
      
      def in_cart?(cartable, owner=nil)
        cart_item_for_cartable_and_owner(cartable, owner).nil?
      end
      
      def cart_item_for_cartable_and_owner(cartable, owner)
        cart_items.for_cartable_and_owner(cartable, owner).first
      end
      
      def refresh
        cart_items.each{|cart_item| cart_item.refresh }
      end
    end
    
    module ClassMethods
      
      def remove_carts(days=7, state=:active)
        expiry_date = (Time.now.midnight - days.days.to_i)
        count = 0

        self.with_state(state).expired(expiry_date).find_in_batches do |batch|
          count += self.delete(batch.map &:id)
        end

        count
      end
      
      # TODO doesn't work for polymorphic assoc
      def add_cart_association(klass)
        klass_key = klass.name.downcase.to_sym
        self.has_many klass_key.to_s.pluralize.to_sym, :through => :cart_items, :source => :cartable, :source_type => klass_key.to_s
      end
    end
  end
end