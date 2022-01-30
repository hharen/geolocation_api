require 'rails_helper'

RSpec.describe 'GeolocationObject', :type => :request do
  fixtures :all

  let(:headers) { { "ACCEPT" => "application/vnd.api+json" } }

  context 'with valid query' do
    it 'returns correct geolocation object' do
      get '/geolocation_objects/?query=84.254.92.149', :headers => headers
      body = JSON.parse(response.body).with_indifferent_access

      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(response).to have_http_status(:ok)
      expect(body).to have_key('data')
      expect(body.dig(:data, :ip)).to eq('84.254.92.149')
    end

    it 'deletes geolocation object' do
      delete '/geolocation_objects/?query=84.254.92.149', :headers => headers

      expect(response.content_type).to eq("application/vnd.api+json")
      expect(response).to have_http_status(:ok)
    end
  end

  context 'with invalid query' do
    it 'returns 404' do
      get '/geolocation_objects/?query=not-a-valid-query', :headers => headers

      expect(response.content_type).to eq("application/vnd.api+json")
      expect(response).to have_http_status(:not_found)
      expect(response.body).to eq('')
    end

    it 'deletes geolocation object' do
      delete '/geolocation_objects/?query=not-a-valid-query', :headers => headers

      expect(response.content_type).to eq("application/vnd.api+json")
      expect(response).to have_http_status(:not_found)
    end
  end
end