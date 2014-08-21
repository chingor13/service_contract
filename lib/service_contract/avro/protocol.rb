module ServiceContract
  module Avro
    class Protocol < AbstractProtocol
      def file_path
        File.join(service.data_dir, "#{name}.avpr")
      end

      def endpoints
        avro.messages.map do |name, message|
          Endpoint.new(self, message)
        end
      end

      def types
        avro.types.map do |type|
          Type.new(type)
        end
      end

      def path
        File.join(service.path, name.pluralize)
      end

      protected

      def avro
        @avro ||= begin
          raise Errors::NotFound unless File.exists?(file_path)

          ::Avro::Protocol.parse(File.read(file_path))
        end
      end
    end
  end
end