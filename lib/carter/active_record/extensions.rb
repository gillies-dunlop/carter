module Carter
  module ActiveRecord
    module Extensions
      def money_converter
        Proc.new { |value| value.respond_to?(:to_money) ? value.to_money : Money.empty }
      end
      
      def money_constructor
        Proc.new { |value| value.respond_to?(:to_money) && !value.blank? ? Money.new(value) : Money.empty }
      end
      
      def money_composed_column(*args)
        options = args.extract_options!
        args.each do |column_name|
          composed_options = {:class_name => '::Money', :mapping => ["#{column_name}", "cents"],
          :converter => money_converter, :constructor => money_constructor}.update(options)
          composed_of column_name, composed_options
        end
      end
    end
  end
end