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
        File.join(service.path, resource_name)
      end

      def main_type
        # convert protocol name to a class like name.  i.e. "city_state" => "CityState"
        name.split("_").map{|o| o.capitalize}.join
      end

      protected

      def resource_name
        name.respond_to?(:pluralize) ? name.pluralize : "#{name}s"
      end

      def avro
        @avro ||= begin
          raise Errors::NotFound unless File.exists?(file_path)

          ::Avro::Protocol.parse(File.read(file_path))
        end
      end
    end
  end
end