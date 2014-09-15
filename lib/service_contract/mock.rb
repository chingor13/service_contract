require 'random-word'

module ServiceContract
  class Mock
    class << self
      # generates fake data that adheres to the types defined in the service contract
      def generate!(version)
        {}.tap do |res|
          type(version).fields.each do |field|
            res[field.name] = mock_value(field)
          end
        end
      end

      private

      def type(version)
        raise :not_implemented
      end

      # can set up custom generators by field name
      #   should be a hash of <field_name> => <lambda>
      def customizations
        {}
      end

      def mock_value(field)
        return customizations[field.name].call if customizations.key?(field.name)

        case field.type
        when "int"
          Random.new.rand(10000000)
        when "string"
          RandomWord.nouns.next
        when "float"
          Random.new.rand(10000.0)
        when "boolean"
          [true, false].sample
        end
      end
    end
  end
end