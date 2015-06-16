require 'sinatra/base'
require 'sparql/client'

class CoolUris < Sinatra::Base
  get '/' do
    uri = RDF::URI.new(params[:uri])
    client = SPARQL::Client.new(ENV["SPARQL_ENDPOINT"])
    result = []
    request.accept.each do |type|
      puts type
      case type.to_s
        when 'application/sparql-results+xml', 'text/rdf+n3', 'text/rdf+ttl', 'text/rdf+turtle', 'text/turtle', 'text/n3', 'application/turtle', 'application/x-turtle', 'application/rdf+xml' then 
              result = client.select.where([uri, RDF::RDFS.isDefinedBy, :page]).result
        when 'text/html', '*/*', 'text/*'
              result = client.select.where([uri, RDF::FOAF.page, :page]).result
      else
        status 406
      end
    end
    if result.size == 1
        puts result.inspect
        redirect result.first[:page], 303
    else
      status 404 
    end
  end


  get '/status' do
    "{\"sparql_endpoint\": #{ENV["SPARQL_ENDPOINT"]}})"
  end  
end
