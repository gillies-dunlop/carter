module Carter
  class << self
    # The Settings instance used to configure the Carter environment
    def settings
      @@settings
    rescue
      raise SetupError, "You must create the Carter settings using the Carter::Initializer.setup method"
    end
    
    def settings=(settings)
      @@settings = settings
    end
    
  end
  
  class Initializer
    attr_reader :settings
    
    def initialize(settings)
      @settings = settings
    end
    
    # setup any defaults in here.
    def process
      Carter.settings = settings
    end
      
    class << self
      
      # This is useful if you only want the load path initialized, without
      # incurring the overhead of completely loading the entire environment.
      def setup(command = :process, settings = Settings.new)
        yield settings if block_given?
        initializer = new settings
        initializer.send(command)
        initializer
      end

    end
  end
  
  class Settings
    attr_accessor :persist_by_shopper
    attr_accessor :on_checkout
    attr_accessor :on_failed
    attr_accessor :cartables
    attr_accessor :default_currency
    attr_accessor :payment_method
    
    def persist_by_shopper?
      @persist_by_shopper
    end

    
    def initialize
      self.cartables = []
    end
    
  end
     
end
