require 'rails/generators'
require "rails/generators/active_record"

module Carter
  module Generators
    class MigrationGenerator < Rails::Generators::Base
      include Rails::Generators::Migration
 
      desc "Generates a migration for cart and cart_item models"
     
      source_root File.expand_path("../templates", __FILE__)

      def self.next_migration_number(path)
        ::ActiveRecord::Generators::Base.next_migration_number(path)
      end

      def copy_migration
        migration_template "migration.rb",  "db/migrate/create_carter.rb"
      end
    end
  end
end