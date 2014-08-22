require 'sinatra/base'
require 'slim'

module ServiceContract
  module Avro
    class Documentation < Sinatra::Base
      get '/:version/:protocol' do
        version = service.find(params[:version])
        protocol = version.protocol(params[:protocol])
        slim :protocol, locals: { version: version, protocol: protocol }
      end

      get '/:version' do
        version = service.find(params[:version])

        if version
          slim :version, locals: { version: version }
        else
          status 404
        end
      end

      get '/' do
        slim :homepage
      end

      helpers do
        def service
          raise :not_implemented
        end
      end
    end
  end
end