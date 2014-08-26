module ServiceContract
  AbstractProtocol = Struct.new(:name, :service) do
    def endpoints
      []
    end

    def endpoint(name)
      endpoints.detect{|endpoint| endpoint.name == name}
    end

    def types
      []
    end

    def type(name)
      types.detect{|type| type.name == name}
    end
  end
end