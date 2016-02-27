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

      def response_type
        Type.build(response)
      end

      def parameters
        request.fields.map{|field| Parameter.new(field) }
      end

      protected

      def request_method
        #Check for [<METHOD>] at the front of the doc string. this signals an action override
        if doc =~ /^\[([A-Z]+)\].+$/
          return $1
        end

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
        when "index", "create"
          protocol.path
        when "show", "destroy", "update"
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
        return false if parameters.empty?

        first_param_type = parameters.first.type
        first_param_type.is_a?(RecordType) && first_param_type.name == protocol.main_type
      end
    end
  end
end
