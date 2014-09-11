module ServiceContract
  module Avro
    class Type < AbstractType
      def name
        array? ? 
          "Array(#{subtype.name})" :
          complex? ?
            definition.name :
            definition.type.to_s
      end

      def fields
        definition.fields.map do |field|
          Parameter.new(field)
        end
      end

      def to_s
        name
      end

      def subtype
        return nil unless definition.respond_to?(:items)
        Type.build(definition.items)
      end

      def array?
        type_string == "array"
      end

      def self.build(definition)
        Type.new(definition)
      end

      def complex?
        type_string == "record"
      end

      def valid_ruby_types
        case type_string
        when "array"
          [Array]
        when "int"
          [Fixnum]
        when "string"
          [String]
        when "float"
          [Float]
        when "boolean"
          [TrueClass, FalseClass]
        else # a complex type
          [Hash]
        end
      end

      protected

      def type_string
        type = definition.type
        type = type.type_sym.to_s if type.respond_to?(:type_sym)
        type
      end

    end
  end
end