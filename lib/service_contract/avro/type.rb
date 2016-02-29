module ServiceContract
  module Avro
    class RecordType < AbstractType
      def name
        definition.name
      end

      def fields
        definition.fields.map do |field|
          Parameter.new(field)
        end
      end

      def valid_ruby_types
        [Hash]
      end
    end

    class ArrayType < AbstractType
      def name
        "Array(#{subtype.name})"
      end

      def subtype
        Type.build(definition.items)
      end

      def valid_ruby_types
        [Array]
      end
    end

    class UnionType < AbstractType
      def name
        "Union(#{union_types.map(&:name).join(", ")})"
      end

      def valid_ruby_types
        union_types.map(&:valid_ruby_types).flatten
      end

      protected

      def union_types
        definition.schemas.map{|schema| Type.build(schema)}
      end
    end

    class EnumType < AbstractType
      def name
        "Enum(#{definition.name})"
      end

      def valid_ruby_types
        [String]
      end

      def valid_values
        definition.symbols.map{|str| str.to_s.downcase}
      end
    end

    class StringType < AbstractType
      def name
        "string"
      end

      def valid_ruby_types
        [String]
      end
    end

    class IntegerType < AbstractType
      def name
        "int"
      end

      def valid_ruby_types
        [Fixnum]
      end
    end

    class FloatType < AbstractType
      def name
        "float"
      end

      def valid_ruby_types
        [Float]
      end
    end

    class BooleanType < AbstractType
      def name
        "boolean"
      end

      def valid_ruby_types
        [TrueClass, FalseClass]
      end
    end

    class NullType < AbstractType
      def name
        "null"
      end
      alias :to_s :name

      def valid_ruby_types
        [NilClass]
      end
    end

    class Type
      class << self
        def build(definition)
          type = type_string(definition)
          case type
          when "array"
            ArrayType.new(definition)
          when "record"
            RecordType.new(definition)
          when "union"
            UnionType.new(definition)
          when "enum"
            EnumType.new(definition)
          when "string"
            StringType.new
          when "int"
            IntegerType.new
          when "float"
            FloatType.new
          when "boolean"
            BooleanType.new
          when "null"
            NullType.new
          else
            raise "unknown type: #{type}"
          end
        end

        def type_string(definition)
          type_string = definition.type
          type_string = type_string.type_sym.to_s if type_string.respond_to?(:type_sym)
          type_string
        end
      end
    end
  end
end
