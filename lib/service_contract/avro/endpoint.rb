require 'forwardable'

module ServiceContract
  module Avro
    class Endpoint < AbstractEndpoint
      extend Forwardable
      def_delegators :definition, :name, :response, :request

      def description
        [request_method, path].join(" ")
      end

      def doc
        definition.respond_to?(:doc) ? definition.doc : nil
      end

      def response_description(data = response)
        case data
        when ::Avro::Schema::ArraySchema
          "Array(#{response_description(data.items)})"
        when ::Avro::Schema::RecordSchema
          data.name
        else
          data.type_sym
        end
      end

      def parameters
        request.fields.map{|field| Parameter.new(field) }
      end

      protected

      def request_method
        case name
        when "create"
          "POST"
        when "update"
          "PUT"
        when "destroy"
          "DELETE"
        else
          "GET"
        end
      end

      def path
        case name
        when "index"
          protocol.path
        when "create"
        when "destroy"
        when "show"
          File.join(protocol.path, ":id")
        else
          if member?
            File.join(protocol.path, ":id", name)
          else
            File.join(protocol.path, name)
          end
        end
      end

      # seems kinda hacky
      def member?
        first_field_type = request.fields.first.type
        first_field_type.is_a?(::Avro::Schema::RecordSchema) &&
          first_field_type.name == protocol.main_type
      end
    end
  end
end