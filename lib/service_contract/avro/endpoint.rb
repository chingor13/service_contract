require 'forwardable'

module ServiceContract
  module Avro
    class Endpoint < AbstractEndpoint
      extend Forwardable
      def_delegators :definition, :doc, :name

      def parameters
        definition.request.fields.map{|field| Parameter.new(field) }
      end
    end
  end
end