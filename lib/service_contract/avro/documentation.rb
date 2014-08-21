require 'sinatra/base'

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
        slim :version, locals: { version: version }
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