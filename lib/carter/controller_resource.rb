module Carter
  # Handle the load cart controller logic so we don't clutter up all controllers with non-interface methods.
  # This class is used internally, so you do not need to call methods directly on it.
  
  class ControllerResource # :nodoc:
    def self.add_before_filter(controller_class, method, *args)
      options = args.extract_options!
      resource_name = args.first
      controller_class.before_filter(options.slice(:only, :except)) do |controller|
        ControllerResource.new(controller, resource_name, options.except(:only, :except)).send(method)
      end
    end

    def initialize(controller, *args)
      @controller = controller
      @params = controller.params
      @session = controller.session
      @options = args.extract_options!
      @name = args.first
    end

    def load_cart
      store_shopping_location if @controller.shopping? && !@controller.checking_out?
      @controller.instance_variable_set("@cart", load_cart_instance)
      @controller.instance_variable_set("@shopper", current_shopper)
    end

    def load_cart_for_checkout
      @controller.instance_variable_set("@cart", load_cart_instance)
      @controller.instance_variable_set("@shopper", current_shopper)
    end
    
    private
    
    def load_cart_instance
      find_cart_by_session || find_cart_by_shopper  || ::Cart.new
    end

    def member_action?
      !collection_actions.include? @params[:action].to_sym
    end
    
    def find_cart_by_shopper
      ::Cart.with_state(default_cart_state).first(:conditions => {:shopper_id => current_shopper.id, :shopper_type => current_shopper.class.name} ) if current_shopper && Carter.settings.persist_by_shopper?
    end
    
    def find_cart_by_session
      ::Cart.with_state(default_cart_state).find_by_id(@session[:cart_id]) 
    end
    
    def current_shopper
      @controller.respond_to?(:current_user) ? @controller.send(:current_user) : nil
    end
    
    def store_shopping_location
      @session[:continue_shopping_url] = @controller.request.fullpath 
    end
    
    def name
      @name || name_from_controller
    end

    def name_from_controller
      @params[:controller].sub("Controller", "").underscore.split('/').last.singularize
    end

    def collection_actions
      [:index] + [@options[:collection]].flatten
    end

    def new_actions
      [:new, :create] + [@options[:new]].flatten
    end
    
    def default_cart_state
      @options[:state] || :active
    end
  end
end
