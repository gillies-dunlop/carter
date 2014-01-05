require 'rails/generators/base'

module Carter
  module Generators
    class InstallGenerator < Rails::Generators::Base

      source_root File.expand_path('../../../../', __FILE__)

      def copy_controller_file
        copy_file "app/controllers/cart_items_controller.rb", "app/controllers/cart_items_controller.rb"
        copy_file "app/controllers/carts_controller.rb", "app/controllers/carts_controller.rb"
      end
      
      def copy_view_file
        copy_file "app/views/carts/show.html.erb", "app/views/carts/show.html.erb"
      end

      protected

      def add_options!(opt)
        opt.separator ''
        opt.separator 'Options:'
        opt.on("--skip-migration", "Don't generate a migration") { |v| options[:skip_migration] = v }
      end
    end
  end
end