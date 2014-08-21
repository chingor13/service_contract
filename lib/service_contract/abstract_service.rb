module ServiceContract
  class AbstractService
    class << self
      def all
        []
      end

      def find(version)
        all.detect{|definition| definition.version == version.to_s}
      end
    end

    attr_reader :version
    def initialize(version)
      @version = version.to_s
    end

    # returns an array of AbstractProtocol
    def protocols
      []
    end

    def protocol(name)
      protocols.detect{|protocol| protocol.name == name}
    end

  end
end