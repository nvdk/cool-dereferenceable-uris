# spec/spec_helper.rb
require 'rack/test'
require 'rspec'
require_relative './lib/api.rb'

ENV['RACK_ENV'] = 'test'


module RSpecMixin
  include Rack::Test::Methods
  def app() CoolUris end
end

RSpec.configure { |c| c.include RSpecMixin }
