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
        return name unless union?
 
        union_types.map(&:name).join(", ")
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

      def union?
        type_string == "union"
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
        when "null"
          [NilClass]
        when "union"
          union_types.map(&:valid_ruby_types).flatten
        else # a complex type
          [Hash]
        end
      end

      protected

      def union_types
        definition.schemas.map{|schema| Type.build(schema)}
      end

      def type_string
        type = definition.type
        type = type.type_sym.to_s if type.respond_to?(:type_sym)
        type
      end

    end
  end
end