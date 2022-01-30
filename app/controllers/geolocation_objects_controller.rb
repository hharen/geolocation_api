class GeolocationObjectsController < ApplicationController
  def index
    geolocation_object = GeolocationObject.where(ip: params['query']).first

    if geolocation_object.present?
      respond_json(status: :ok, response: geolocation_object)
    else 
      respond_json(status: :not_found) #TO DO: test this
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

#Add? Accept: application/vnd.api+json
