class GeolocationObjectsController < ApplicationController
  require 'uri'
  require 'net/http'

  SERVICE_PROVIDER = 'http://api.ipstack.com/'
  API_KEY = ENV['ip_stack_api_key']

  def get_an_object
    geolocation_object = GeolocationObject.find_by(ip: params['query'])

    if geolocation_object.present?
      respond_json(status: :ok, response: geolocation_object)
    else 
      respond_json(status: :not_found)
    end
  end

  def create
    ip = params[:query]

    uri = URI("#{SERVICE_PROVIDER}/#{ip}?access_key=#{API_KEY}")
    response = Net::HTTP.get_response(uri)
    body = JSON.parse(response.body).with_indifferent_access

    geolocation_object = GeolocationObject.new(
      url: body[:url],
      ip: body[:ip],
      ip_type: body[:type],
      continent_code: body[:continent_code],
      continent_name: body[:continent_name],
      country_code: body[:country_code],
      country_name: body[:country_name],
      region_code: body[:region_code],
      region_name: body[:region_name],
      city: body[:city],
      zip: body[:zip]
    )

    if geolocation_object.save
      respond_json(status: :created)
    else
      respond_json(status: :unprocessable_entity)
    end
  end

  def destroy
    geolocation_object = GeolocationObject.find_by(ip: params['query'])
    if geolocation_object.present?
      geolocation_object.destroy
      respond_json(status: :ok)
    else
      respond_json(status: :not_found) # ADD SOME SENSIBLE ERROR MESSAGE?
    end
  end

  private 

  def respond_json(status: :ok, response: nil, content_type: {"Content-Type" => "application/vnd.api+json"})
    if response.present?
      render status: status, headers: content_type, json: { data: response }
    else
      head status, content_type
    end
  end
end

# TO DO:
# Errors:
# query can't be null
# what if service provider is down?

#Add? Accept: application/vnd.api+json

# should I check if ip from query is same as ip from ipstack?
# Dont' save duplicates
# HANDLE URL

