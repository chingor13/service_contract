module ServiceContract
  module Avro
    class Type < AbstractType
      def name
        definition.name
      end

      def type
        if record?
          definition.type.name
        else
          definition.type.type_sym.to_s
        end
      end

      def fields
        definition.fields.map do |field|
          Parameter.new(field)
        end
      end

      protected

      def record?
        definition.type.type_sym == :record
      end
    end
  end
end