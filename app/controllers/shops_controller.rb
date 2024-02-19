require 'net/http'
require 'uri'

class ShopsController < ApplicationController
  def index
    @shops = Shop.all
  end

  def show
  end

  def search


    url = URI.parse('https://places.googleapis.com/v1/places:searchText')
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    searchData = {
      "textQuery": params[:genre],
      "languageCode": "ja",
      "locationBias": {
        "circle": {
          "center": {
            "latitude": 34.65112098708317,
            "longitude": 135.58856512184337,
          },
          "radius": 200.0,
        }
      },
      "openNow": true
    }

  headers = {
    'Content-Type' => 'application/json',
    'X-Goog-Api-Key' => ENV["GOOGLE_PLACE_API_KEY"],
    'X-Goog-FieldMask' => 'places.displayName,places.formattedAddress,places.rating'
  }

  request = Net::HTTP::Post.new(url.path, headers)
  request.body = searchData.to_json
  response = http.request(request)

  
  if response.code.to_i == 200
    result = JSON.parse(response.body)
    @shops = result["places"].sort_by{|place| place["rating"] }.reverse
    render :index
  else
    puts "API request failed with status #{response.code}"
    redirect_to shops_show_path
  end

  end


end
