require 'sinatra/base'
require 'sparql/client'
require 'json' 

class CoolUris < Sinatra::Base
  configure do
    set :sparql_client, SPARQL::Client.new(ENV['SPARQL_ENDPOINT'])
  end

  get '/' do
    # verify request
    unless params[:uri]
      halt 400, { error:"query parameter uri is required"}.to_json
    end
    
    # request representations for uri
    uri = params[:uri]
    query  = "SELECT ?pageURL ?dataURL WHERE {"
    query += "  OPTIONAL { <#{uri}> <#{RDF::RDFS.isDefinedBy}> ?dataURL.}"
    query += "  OPTIONAL { <#{uri}> <#{RDF::FOAF.page}> ?pageURL.}"
    query += "}"
    result = query(query)
    info = result.first ? result.first : nil

    # verify URI has at least one representation
    unless info && (info['dataURL'] || info['pageURL'])
      halt 404, { error: "#{uri} does not seem to exist"}.to_json
    end    

    # content negotiation
    if accepts_rdf?(request.accept) && info['dataURL']
     redirect info['dataURL'], 303
    elsif accepts_html?(request.accept) && info['pageURL']
      redirect info['pageURL'], 303
    elsif accepts_html?(request.accept) && info['dataURL']
      redirect info['dataURL'], 303
    else
      halt 406, { error: "#{uri} is not available in the requested format"}.to_json
    end
  end

  get '/status' do
    "{\"sparql_endpoint\": #{ENV["SPARQL_ENDPOINT"]}})"
  end  

  helpers do
    # query helper, uses configured sparql client to query
    def query(query)
      settings.sparql_client.query query
    end
    # check if the accept headers contain at least one of the known rdf serialization formats
    def accepts_rdf?(accept_headers)
      rdf_types = ['application/sparql-results+xml', 'text/rdf+n3', 'text/rdf+ttl', 'text/rdf+turtle', 'text/turtle', 'text/n3', 'application/turtle', 'application/x-turtle', 'application/rdf+xml']
      intersection = accept_headers.map(&:to_s) & rdf_types
      intersection.size > 0
    end
    # check if the accepts headers contain a html compatible format
    def accepts_html?(accept_headers)
      html_types = ['text/html', '*/*', 'text/*']
      intersection = accept_headers.map(&:to_s) & html_types
      intersection.size > 0
    end
  end
end
