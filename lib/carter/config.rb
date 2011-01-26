module Carter
  class Config
    class << self
      def cartables
        @cartables ||= [] 
      end
      
      def cartables=(value)
        @cartables = value
      end
      
      def on_checkout=(value)
        @on_checkout = value
      end
      
      def on_checkout
        @on_checkout || nil
      end
      
      def on_failed=(value)
        @on_failed = value
      end
      
      def on_failed
        @on_failed || nil
      end
    end
  end
end
