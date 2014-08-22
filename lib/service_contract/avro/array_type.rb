module ServiceContract
  module Avro
    class ArrayType < Type
      def name
        "Array"
      end

      def subtype
        Type.build(definition.items)
      end

      def to_s
        "Array(#{subtype.to_s})"
      end
    end
  end
end