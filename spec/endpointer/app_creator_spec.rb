require 'spec_helper'
require 'endpointer/response'
require 'rack/test'

describe Endpointer::AppCreator do
  include Rack::Test::Methods
  let(:url1) { "http://example.com/foo" }
  let(:url2) { "http://example.com/bar" }
  let(:invalidate) { true }
  let(:resource1) { Endpointer::Resource.new("resource1", :get, url1, {'Authorization' => 'Bearer bar'}) }
  let(:resource2) { Endpointer::Resource.new("resource2", :post, url2, {}) }
  let(:resources) { [resource1, resource2] }
  let(:options) { Endpointer::Options.new(invalidate) }

  before do
    stub_const('Endpointer::ResourceExecutor', Endpointer::ResourceExecutorStub)
  end

  describe '#create' do
    it 'creates a sinatra endpointer app with all configured resources' do
      path = URI.parse(url1).path
      get path
      expect(last_response.body).to eq(path)
      expect(last_response.headers['Authorization']).to eq(resource1.headers['Authorization'])

      path = URI.parse(url2).path
      post path
      expect(last_response.body).to eq(path)
    end
  end

  def app
    subject.create(resources, options)
  end
end

class Endpointer::ResourceExecutorStub < Endpointer::ResourceExecutor
  def perform(request, resource, options)
    Endpointer::Response.new(200, request.path, resource.headers)
  end
end
