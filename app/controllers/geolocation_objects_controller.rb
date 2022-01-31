class GeolocationObjectsController < ApplicationController
  require 'uri'
  require 'net/http'

  SERVICE_PROVIDER = 'http://api.ipstack.com/'
  API_KEY = ENV['ip_stack_api_key']

  # Get an object
  #
  # GET /geolocation_objects/{query}
  # Response
  #
  # Status: 200 OK
  # {object data}
  # Objects that are not on the server will return a 404 Not Found.
  def get_object
    geolocation_object = find_object(params)

    if geolocation_object.present?
      respond_json(status: :ok, response: geolocation_object)
    else 
      respond_json(status: :not_found)
    end
  end

  # Create an object
  #
  # POST /geolocation_objects/{query}
  # Response
  #
  # Status: 201 CREATED
  # {object data}
  # If object can't be saved it returns 422
  def create
    query = params[:query]

    begin
      uri = URI("#{SERVICE_PROVIDER}/#{query}?access_key=#{API_KEY}")
      response = Net::HTTP.get_response(uri)
      body = JSON.parse(response.body).with_indifferent_access
    rescue Exception => e
      logger.error e.message
      logger.error e.backtrace.join("\n")
      respond_json(status: :service_unavailable) # if service provider is down
      return
    end

    geolocation_object = GeolocationObject.new(
      url: query == body[:ip] ? nil : query, # return url from query if query is not ip address
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

  # Delete an object
  #
  # DELETE /geolocation_objects/{query}
  # Response
  #
  # Status: 200 OK
  # If object is not found it will return 404 Not Found

  def destroy
    geolocation_object = find_object(params)
    if geolocation_object.present?
      begin
        geolocation_object.destroy!
        respond_json(status: :ok)
      rescue Exception => e
        Rails.logger.debug { "Couldn't delete the object." }
        logger.error e.message
        logger.error e.backtrace.join("\n")
        respond_json(status: :internal_server_error)
      end
    else
      respond_json(status: :not_found)
    end
  end

  private 

  def find_object(params)
    return nil if params['query'].nil?
    GeolocationObject.find_by(ip: params['query']) || GeolocationObject.find_by(url: params['query'])
  end

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
# what if service provider is down?

# Add? Accept: application/vnd.api+json