module ServiceContract
  AbstractEndpoint = Struct.new(:protocol, :definition) do
    def parameters
      []
    end
  end
end