class CarterInstallGenerator < Rails::Generator::Base
  default_options :skip_migration => false
  
  def copy_controller_file
    copy_file "cart_items_controller.rb", "app/controllers"
    copy_file "carts_controller.rb", "app/controllers"
  end
  
  def copy_view_file
    copy_file "carts/show.html.erb", "app/views/carts"
  end
protected

  def add_options!(opt)
    opt.separator ''
    opt.separator 'Options:'
    opt.on("--skip-migration", "Don't generate a migration") { |v| options[:skip_migration] = v }
  end
  
end
