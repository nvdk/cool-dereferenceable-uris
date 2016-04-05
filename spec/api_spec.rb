require_relative '../spec_helper'

describe "purl api" do
  it "should redirect to the html view when accept header specified html" do    
    result = RDF::Query::Solution.new pageURL: 'http://html', dataURL: 'http://rdf'
    expect(app.settings.sparql_client).to receive(:query).and_return([result])
    header 'ACCEPT', 'text/html'
    get '/?uri=http://some.test/id/foo'
    expect(last_response.status).to eq(303)
    expect(last_response.location).to eq('http://html')
  end

  it "should redirect to the rdf view when accept header specifies rdf" do
    result = RDF::Query::Solution.new pageURL: 'http://html', dataURL: 'http://rdf'
    expect(app.settings.sparql_client).to receive(:query).and_return([result])
    header 'ACCEPT', 'application/rdf+xml'
    get '/?uri=http://some.test/id/foo'
    expect(last_response.status).to eq(303)
    expect(last_response.location).to eq('http://rdf')
  end

  it "should return a 404 if the uri is not present in the endpoint" do
    result = RDF::Query::Solution.new pageURL: nil, dataURL: nil
    expect(app.settings.sparql_client).to receive(:query).and_return([result])
    header 'ACCEPT', 'application/rdf+xml'
    get '/?uri=http://some.test/id/foo'
    expect(last_response).to be_not_found

  end
  it "should return a 400 bad request when the uri request param is not set" do
    get '/'
    expect(last_response).to be_bad_request
  end
  
  it "should return a 406 when a non supported format is specified in the accept header" do
    result = RDF::Query::Solution.new pageURL: 'http://html', dataURL: 'http://rdf'
    expect(app.settings.sparql_client).to receive(:query).and_return([result])
    header 'ACCEPT', 'application/vnd.ms-excel'
    get '/?uri=http://some.test/id/foo'
    expect(last_response.status).to eq(406)
  end
end
