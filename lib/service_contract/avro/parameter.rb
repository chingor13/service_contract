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

      def doc
        definition.doc
      end
    end
  end
end