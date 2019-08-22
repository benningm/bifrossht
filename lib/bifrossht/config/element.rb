module Bifrossht
  class Config
    class Element
      def initialize(options = {})
        @options = options
      end

      private

      def validate_presence(*options)
        options.each do |name|
          raise ParameterError, "#{self.class.name} is missing parameter #{name}" unless @options.key?(name)
        end
      end

      def validate_type(option, type)
        return unless @options.key?(option)

        raise ParameterError, "option #{option} for #{self.class} is not of type #{type}" unless @options[option].is_a? type
      end

      def validate_enum(option, values)
        return unless @options.key?(option)

        value = @options[option]
        raise ParameterError, "option #{option} for #{self.class} does not allow value #{value}" unless values.include?(value)
      end

      def validate_boolean(option)
        validate_enum(option, [true, false])
      end
    end
  end
end
