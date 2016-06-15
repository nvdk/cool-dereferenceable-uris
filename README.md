# Cool dereferenceable uris [![Build Status](https://travis-ci.org/nvdk/cool-dereferenceable-uris.svg?branch=master)](https://travis-ci.org/nvdk/cool-dereferenceable-uris)

A simple web api that dereferences real world objects in a sparql endpoint following the [cool uri's strategy](http://www.w3.org/TR/cooluris/).
The api takes a query parameter "uri" and will dereference to the data view or the html view based on accept headers, based on data available in the endpoint.

Example triples:

```
<http://your-awesome.uri> rdfs:isDefinedBy <http://the-awesome-data-url>
<http://your-awesome.uri> foaf:page <http://the-awesome-html-url>
```

## Installation 
### java
```
wget https://github.com/nvdk/cool-dereferenceable-uris/releases/download/v1.0.0/cool-dereferenceable-uris.war
java -jar -Dwarbler.port=80 cool-dereferenceable-uris.war 
```

### ruby
```
git clone https://github.com/nvdk/cool-dereferenceable-uris.git
bundle install
rackup
```

## Usage
curl http://localhost/?uri=<uriEncode(http://your-uri/id/my-id)>


## License
See [LICENSE](LICENSE)
