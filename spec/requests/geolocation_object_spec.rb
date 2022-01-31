require 'rails_helper'

RSpec.describe 'GeolocationObject', :type => :request do
  fixtures :all

  let(:headers) { { 'Accept' => 'application/vnd.api+json', 'Authorization' => ENV['authorization_token'] } }

  describe '#object' do
    context 'with valid query' do
      it 'returns correct geolocation object based on ip address' do
        get '/geolocation_objects/?query=84.254.92.149', :headers => headers
        body = JSON.parse(response.body).with_indifferent_access

        expect(response.content_type).to eq("application/json; charset=utf-8")
        expect(response).to have_http_status(:ok)
        expect(body).to have_key('data')
        expect(body.dig(:data, :ip)).to eq('84.254.92.149')
      end

      it 'returns correct geolocation object based on url' do
        get '/geolocation_objects/?query=professional.ch', :headers => headers
        body = JSON.parse(response.body).with_indifferent_access

        expect(response.content_type).to eq("application/json; charset=utf-8")
        expect(response).to have_http_status(:ok)
        expect(body).to have_key('data')
        expect(body.dig(:data, :ip)).to eq('34.65.137.34')
      end
    end

    context 'with invalid query' do
      it 'returns 404' do
        get '/geolocation_objects/?query=not-a-valid-query', :headers => headers

        expect(response.content_type).to eq("application/vnd.api+json")
        expect(response).to have_http_status(:not_found)
        expect(response.body).to eq('')
      end
    end

    context 'with invalid token' do
      headers_invalid_token = { 'Accept' => 'application/vnd.api+json', 'Authorization' => 'incorrect-token' }
      it 'returns 401' do
        get '/geolocation_objects/?query=not-a-valid-query', :headers =>  headers_invalid_token

        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to eq('')
      end
    end
  end

  describe '#create' do
    context 'with valid query' do
      it 'creates geolocation object based on ip' do
        expect do
          post '/geolocation_objects/?query=194.40.230.0', :headers => headers
        end.to change(GeolocationObject, :count).by(1)

        expect(response.content_type).to eq("application/vnd.api+json")
        expect(response).to have_http_status(:created)
      end

      it 'creates geolocation object based on url' do
        expect do
          post '/geolocation_objects/?query=rubymonstas.ch', :headers => headers
        end.to change(GeolocationObject, :count).by(1)

        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid query' do
      it 'does not create geolocation object' do
        expect do
          post '/geolocation_objects/?query=not-a-valid-query', :headers => headers
        end.not_to change(GeolocationObject, :count)

        expect(response.content_type).to eq("application/vnd.api+json")
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'does not create geolocation object without query' do
        expect do
          post '/geolocation_objects/', :headers => headers
        end.not_to change(GeolocationObject, :count)

        expect(response).to have_http_status(:service_unavailable)
      end
    end
  end

  describe '#destroy' do
    context 'with valid query' do
      it 'deletes geolocation object based on ip' do
        expect do
          delete '/geolocation_objects/?query=84.254.92.149', :headers => headers
        end.to change(GeolocationObject, :count).by(-1)

        expect(response.content_type).to eq("application/vnd.api+json")
        expect(response).to have_http_status(:ok)
      end

      it 'deletes geolocation object based on url' do
        expect do
          delete '/geolocation_objects/?query=professional.ch', :headers => headers
        end.to change(GeolocationObject, :count).by(-1)

        expect(response.content_type).to eq("application/vnd.api+json")
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid query' do
      it 'does not delete geolocation object' do
        expect do
          delete '/geolocation_objects/?query=not-a-valid-query', :headers => headers
        end.not_to change(GeolocationObject, :count)

        expect(response.content_type).to eq("application/vnd.api+json")
        expect(response).to have_http_status(:not_found)
      end

      it 'does not delete geolocation object without query' do
        expect do
          delete '/geolocation_objects/', :headers => headers
        end.not_to change(GeolocationObject, :count)

        expect(response.content_type).to eq("application/vnd.api+json")
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end