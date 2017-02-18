# encoding: utf-8

module TTY
  class Prompt
    # Immutable collection of converters for type transformation
    #
    # @api private
    class ConverterRegistry
      # Create a registry of conversions
      #
      # @param [Hash] registry
      #
      # @api private
      def initialize(registry = {})
        @_registry = registry.dup.freeze
        freeze
      end

      # Register converter
      #
      # @param [Symbol] name
      #   the converter name
      #
      # @api public
      def register(name, contents = nil, &block)
        item = block_given? ? block : contents

        if key?(name)
          raise ArgumentError,
                "Converter for #{name.inspect} already registered"
        end
        self.class.new(@_registry.merge(name => item))
      end

      # Check if converter is registered
      #
      # @return [Boolean]
      #
      # @api public
      def key?(key)
        @_registry.key?(key)
      end

      # Execute converter
      #
      # @api public
      def call(key, input)
        if key.respond_to?(:call)
          converter = key
        else
          converter = @_registry.fetch(key) do
            raise ArgumentError, "#{key.inspect} is not registered"
          end
        end
        converter.call(input)
      end

      def inspect
        @_registry.inspect
      end
    end # ConverterRegistry
  end # Prompt
end # TTY
