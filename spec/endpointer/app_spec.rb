require 'spec_helper'
require 'rack/test'

describe Endpointer::App do
  include Rack::Test::Methods

  let(:expected_response) do
    {
      'error' => 'URL not configured. You need to configure all urls that Endpointer will listen to in your json file'
    }
  end

  describe 'not_found' do
    it 'returns a 404 json object asking you to configure it' do
      get '/anything'
      expect(JSON.parse(last_response.body)).to eq(expected_response)
      expect(last_response.status).to eq(404)
    end
  end

  def app
    Endpointer::App
  end
end
