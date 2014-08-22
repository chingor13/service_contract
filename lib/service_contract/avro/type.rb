module ServiceContract
  module Avro
    class Type < AbstractType
      def name
        definition.name
      end

      def fields
        definition.fields.map do |field|
          Parameter.new(field)
        end
      end

      def to_s
        name
      end

      def self.build(definition)
        definition.is_a?(::Avro::Schema::ArraySchema) ? 
          ArrayType.new(definition) :
          Type.new(definition)
      end

      protected

      def record?
        definition.type.type_sym == :record
      end
    end
  end
end