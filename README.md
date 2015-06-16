# Cool dereferenceable uris
A simple web api that dereferences real world objects in a sparql endpoint following the [cool uri's strategy](http://www.w3.org/TR/cooluris/).
The api takes a query parameter "uri" and will dereference to the data view or the html view based on accept headers, based on data available in the endpoint.

Example triples:

```
<http://your-awesome.uri> rdfs:definedBy <http://the-awesome-data-url>
<http://your-awesome.uri> foaf:page <http://the-awesome-html-url>
```

## Installation 
### jruby
```
bundle install
gem install warble
warble executable war
java -jar -Dwarbler.port=80 cool-dereferenceable-uris.war 
```

### ruby
```
bundle install
rackup
```

## Usage
curl http://localhost/?uri=<http://your-uri/id/my-id>


## License
See [LICENSE](LICENSE)
