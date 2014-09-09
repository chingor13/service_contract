module ServiceContract
  module Avro
    class Parameter < AbstractParameter
      def name
        definition.name
      end

      def type
        definition.type.type_sym == :record ?
          definition.type.name :
          definition.type.type_sym.to_s
      end

      def subtype
        item = definition.type.is_a?(::Avro::Schema::ArraySchema) ?
                definition.type.items :
                nil
        return nil unless item

        item.is_a?(::Avro::Schema::PrimitiveSchema) ?
          item.type_sym.to_s :
          item
      end

      def default
        definition.default
      end

      def doc
        definition.respond_to?(:doc) ? definition.doc : nil
      end
    end
  end
end