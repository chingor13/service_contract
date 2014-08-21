module ServiceContract
  module Avro
    class Service < AbstractService
      class << self
        def all
          @all ||= begin
            Dir.glob(File.join(data_dir, "*")).map do |filepath|
              new(File.basename(filepath).to_s)
            end
          end
        end

        def data_dir
          raise :not_implemented
        end

        def title
          "Avro Service"
        end

        def description
          ""
        end

      end

      def protocols
        @protocols ||= begin
          Dir.glob(File.join(data_dir, "*.avpr")).map do |filepath|
            name = File.basename(filepath, ".avpr")
            Protocol.new(name, self)
          end
        end
      end

      def path
        "/#{version}"
      end

      def data_dir
        File.join(self.class.data_dir, version, "compiled")
      end
    end
  end
end