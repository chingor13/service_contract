# ServiceContract [![Build Status](https://travis-ci.org/chingor13/service_contract.png)](https://travis-ci.org/chingor13/service_contract) [![Code Climate](https://codeclimate.com/github/chingor13/service_contract.png)](https://codeclimate.com/github/chingor13/service_contract) [![Code Coverage](https://codeclimate.com/github/chingor13/service_contract/coverage.png)](https://codeclimate.com/github/chingor13/service_contract)

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

## Documentation

`service_contract` also provides a nice documentation layer packaged in the form of a [sinatra](http://www.sinatrarb.com/) rack application. 

```
module Gnomon
  module Contract
    class Documentation < ServiceContract::Avro::Documentation
      helpers do
        def service
          Gnomon::Contract::Service
        end
      end
    end
  end
end

# in your rackup config
run Gnomon::Contract::Documentation

# or mount in rails routes
MyApplication.routes.draw do
  mount Gnomon::Contract::Documentation, at: "docs/"
end
```

**Note**: You will have to add `sinatra` and `slim` (templating engine) to your gem dependencies yourself because it's not a core dependency.