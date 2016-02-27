module ServiceContract
  module Avro
    class Parameter < AbstractParameter
      def name
        definition.name
      end

      def type
        Type.build(definition.type)
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
