require "service_contract/version"

module ServiceContract
  autoload :AbstractEndpoint, 'service_contract/abstract_endpoint'
  autoload :AbstractParameter, 'service_contract/abstract_parameter'
  autoload :AbstractProtocol, 'service_contract/abstract_protocol'
  autoload :AbstractService, 'service_contract/abstract_service'
  autoload :AbstractType, 'service_contract/abstract_type'

  # test hooks
  autoload :Assertions, 'service_contract/assertions'
  autoload :Mock, 'service_contract/mock'

  # providers
  autoload :Avro, 'service_contract/avro'
end
