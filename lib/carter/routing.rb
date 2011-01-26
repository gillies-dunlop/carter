module Carter #:nodoc:
  module Routing #:nodoc:
    module MapperExtensions
      def carter_routes(options={})
        self.resources :carts
        self.resources :cart_items
        
      end
    end
  end
end