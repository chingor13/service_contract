# ServiceContract

The gem tries to abstract the definition of a service's interface contract

## Installation

Add this line to your application's Gemfile:

```
gem 'service_contract'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install service_contract

## Providers

### Avro

We can read an Avro protocol file to determine a set of service definitions.

Example:

```
class Gnomon::Contract::Service < ServiceContract::Avro::Service
  def self.data_dir
  	return "/path/to/avro_files"
  end
end
```

## Usage

We define a service as having many versions with each version having several `Protocol`s. A `Protocol` has many `Endpoint`s.

Example:

```
# a Gnomon::Contract::Service instance (subclass of ServiceContract::AbstractService)
version = Gnomon::Contract::Service.find(1)
=> <#Gnomon::Contract::Service>

protocol = version.protocol("location")
=> <#ServiceContract::Avro::Protocol>

protocol.endpoints
=> [<#ServiceContract::Avro::Endpoint>,...]
```