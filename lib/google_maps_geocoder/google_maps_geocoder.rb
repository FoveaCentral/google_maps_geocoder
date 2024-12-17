# Copyright the GoogleMapsGeocoder contributors.
# SPDX-License-Identifier: MIT
# frozen_string_literal: true

require 'json'
require 'logger'
require 'net/http'
require 'rack'

# A simple PORO wrapper for geocoding with Google Maps.
#
# @example
#   chez_barack = GoogleMapsGeocoder.new '1600 Pennsylvania DC'
#   chez_barack.formatted_address
#     => "1600 Pennsylvania Avenue Northwest, President's Park,
#         Washington, DC 20500, USA"
# rubocop:disable Metrics/ClassLength
class GoogleMapsGeocoder
  GOOGLE_ADDRESS_SEGMENTS = %i[
    city country_long_name country_short_name county lat lng postal_code
    state_long_name state_short_name
  ].freeze
  private_constant :GOOGLE_ADDRESS_SEGMENTS
  GOOGLE_MAPS_API = 'https://maps.googleapis.com/maps/api/geocode/json'
  private_constant :GOOGLE_MAPS_API
  ALL_ADDRESS_SEGMENTS = (
    GOOGLE_ADDRESS_SEGMENTS + %i[formatted_address formatted_street_address]
  ).freeze
  private_constant :ALL_ADDRESS_SEGMENTS

  # Returns the complete formatted address with standardized abbreviations.
  #
  # @return [String] the complete formatted address
  # @example
  #   chez_barack.formatted_address
  #     => "1600 Pennsylvania Avenue Northwest, President's Park,
  #         Washington, DC 20500, USA"
  attr_reader :formatted_address

  # Returns the formatted street address with standardized abbreviations.
  #
  # @return [String] the formatted street address
  # @example
  #   chez_barack.formatted_street_address
  #     => "1600 Pennsylvania Avenue Northwest"
  attr_reader :formatted_street_address
  # Self-explanatory
  attr_reader(*GOOGLE_ADDRESS_SEGMENTS)

  # Returns the formatted address as a comma-delimited string.
  alias address formatted_address
  # Returns the address' country as a full string.
  alias country country_long_name
  # Returns the address' country as an abbreviated string.
  alias country_code country_short_name
  # Returns the address' latitude as a float.
  alias latitude lat
  # Returns the address' longitude as a float.
  alias longitude lng
  # Returns the address' state as a full string.
  alias state state_long_name
  # Returns the address' state as an abbreviated string.
  alias state_code state_short_name

  # Geocodes the specified address and wraps the results in a GoogleMapsGeocoder
  # object.
  #
  # @param address [String] a geocodable address
  # @param logger [Logger] a standard Logger, defaults to standard error
  # @return [GoogleMapsGeocoder] the Google Maps result for the specified
  #   address
  # @example
  #   chez_barack = GoogleMapsGeocoder.new '1600 Pennsylvania DC'
  def initialize(address, logger: Logger.new($stderr))
    @json = address.is_a?(String) ? google_maps_response(address) : address
    status = @json && @json['status']
    raise RuntimeError if status == 'OVER_QUERY_LIMIT'
    raise GeocodingError.new(@json, logger: logger) if !@json || @json.empty? || status != 'OK'

    set_attributes_from_json
    logger.info('GoogleMapsGeocoder') { "Geocoded \"#{address}\" => \"#{formatted_address}\"" }
  end

  # Returns the address' coordinates as an array of floats.
  def coordinates
    [lat, lng]
  end

  # Returns true if the address Google returns is an exact match.
  #
  # @return [boolean] whether the Google Maps result is an exact match
  # @example
  #   chez_barack.exact_match?
  #     => true
  def exact_match?
    !partial_match?
  end

  # Returns true if the address Google returns isn't an exact match.
  #
  # @return [boolean] whether the Google Maps result is a partial match
  # @example
  #   GoogleMapsGeocoder.new('1600 Pennsylvania DC').partial_match?
  #     => true
  def partial_match?
    @json['results'][0]['partial_match'] == true
  end

  # A geocoding error returned by Google Maps.
  class GeocodingError < RuntimeError
    # Returns the complete JSON response from Google Maps as a Hash.
    #
    # @return [Hash] Google Maps' JSON response
    # @example
    #   {
    #     "results" => [],
    #     "status" => "ZERO_RESULTS"
    #   }
    attr_reader :json

    # Initialize a GeocodingError wrapping the JSON returned by Google Maps.
    #
    # @param json [Hash] Google Maps' JSON response
    # @return [GeocodingError] the geocoding error
    def initialize(json = {}, logger:)
      @json = json
      if (message = @json['error_message'])
        logger.error "GeocodingError.new: #{message}"
      end
      super(@json)
    end
  end

  private

  def google_maps_request(address)
    "#{GOOGLE_MAPS_API}?address=#{Rack::Utils.escape address}" \
      "&key=#{ENV.fetch('GOOGLE_MAPS_API_KEY', nil)}"
  end

  def google_maps_response(address)
    uri = URI.parse google_maps_request(address)
    response = http(uri).request(Net::HTTP::Get.new(uri.request_uri))
    JSON.parse response.body
  end

  def http(uri)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    http
  end

  def parse_address_component_type(type, name = 'long_name')
    address_component = @json['results'][0]['address_components'].detect do |ac|
      ac['types']&.include?(type)
    end
    address_component && address_component[name]
  end

  def parse_city
    parse_address_component_type('sublocality') ||
      parse_address_component_type('locality')
  end

  def parse_country_long_name
    parse_address_component_type('country')
  end

  def parse_country_short_name
    parse_address_component_type('country', 'short_name')
  end

  def parse_county
    parse_address_component_type('administrative_area_level_2')
  end

  def parse_formatted_address
    @json['results'][0]['formatted_address']
  end

  def parse_formatted_street_address
    "#{parse_address_component_type('street_number')} " \
      "#{parse_address_component_type('route')}"
  end

  def parse_lat
    @json['results'][0]['geometry']['location']['lat']
  end

  def parse_lng
    @json['results'][0]['geometry']['location']['lng']
  end

  def parse_postal_code
    parse_address_component_type('postal_code')
  end

  def parse_state_long_name
    parse_address_component_type('administrative_area_level_1')
  end

  def parse_state_short_name
    parse_address_component_type('administrative_area_level_1', 'short_name')
  end

  def set_attributes_from_json
    ALL_ADDRESS_SEGMENTS.each do |segment|
      instance_variable_set :"@#{segment}", send(:"parse_#{segment}")
    end
  end
end
# rubocop:enable Metrics/ClassLength
