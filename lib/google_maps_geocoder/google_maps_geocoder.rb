require 'active_support'
require 'active_support/core_ext/string/inflections'
require 'logger'
require 'net/http'
require 'rack'

# A simple PORO wrapper for geocoding with Google Maps.
#
# @example
#   chez_barack = GoogleMapsGeocoder.new '1600 Pennsylvania Ave'
#   chez_barack.formatted_address
#     => "1600 Pennsylvania Avenue Northwest, President's Park,
#         Washington, DC 20500, USA"
# rubocop:disable Metrics/ClassLength
class GoogleMapsGeocoder
  # Error handling for google statuses
  class GeocodingError < StandardError
    # Initialize an error class wrapping the error returned by Google Maps.
    #
    # @return [GeocodingError] the geocoding error
    def initialize(response_json = '')
      @json = response_json
      super
    end

    # Returns the GeocodingError's content.
    #
    # @return [String] the geocoding error's content
    def message
      "Google returned:\n#{@json.inspect}"
    end
  end

  class ZeroResultsError < GeocodingError; end
  class QueryLimitError < GeocodingError; end
  class RequestDeniedError < GeocodingError; end
  class InvalidRequestError < GeocodingError; end
  class UnknownError < GeocodingError; end

  ERROR_STATUSES = { zero_results: 'ZERO_RESULTS',
                     query_limit: 'OVER_QUERY_LIMIT',
                     request_denied: 'REQUEST_DENIED',
                     invalid_request: 'INVALID_REQUEST',
                     unknown: 'UNKNOWN_ERROR' }.freeze

  GOOGLE_ADDRESS_SEGMENTS = %i(
    city country_long_name country_short_name county lat lng postal_code
    state_long_name state_short_name
  ).freeze
  GOOGLE_API_URI = 'https://maps.googleapis.com/maps/api/geocode/json'.freeze

  ALL_ADDRESS_SEGMENTS = (
    GOOGLE_ADDRESS_SEGMENTS + %i(
      formatted_address formatted_street_address
    )
  ).freeze

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
  #     => "1600 Pennsylvania Avenue"
  attr_reader :formatted_street_address
  # Self-explanatory
  attr_reader(*GOOGLE_ADDRESS_SEGMENTS)

  # Geocodes the specified address and wraps the results in a GoogleMapsGeocoder
  # object.
  #
  # @param data [String] a geocodable address
  # @return [GoogleMapsGeocoder] the Google Maps result for the specified
  #   address
  # @example
  #   chez_barack = GoogleMapsGeocoder.new '1600 Pennsylvania Ave'
  def initialize(data)
    @json = data.is_a?(String) ? json_from_url(data) : data
    handle_error if @json.blank? || @json['status'] != 'OK'
    set_attributes_from_json
    logger.info('GoogleMapsGeocoder') do
      "Geocoded \"#{data}\" => \"#{formatted_address}\""
    end
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
  #   GoogleMapsGeocoder.new('1600 Pennsylvania Washington').partial_match?
  #     => true
  def partial_match?
    @json['results'][0]['partial_match'] == true
  end

  private

  def self.error_class_name(key)
    "google_maps_geocoder/#{key}_error".classify.constantize
  end
  private_class_method :error_class_name

  def api_key
    @api_key ||= "&key=#{ENV['GOOGLE_MAPS_API_KEY']}" if
      ENV['GOOGLE_MAPS_API_KEY']
  end

  def http(uri)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    http
  end

  def json_from_url(url)
    uri = URI.parse query_url(url)

    logger.debug('GoogleMapsGeocoder') { uri }

    response = http(uri).request(Net::HTTP::Get.new(uri.request_uri))
    ActiveSupport::JSON.decode response.body
  end

  def handle_error
    status = @json['status']
    message = GeocodingError.new(@json).message

    # for status codes see https://developers.google.com/maps/documentation/geocoding/intro#StatusCodes
    ERROR_STATUSES.each do |key, value|
      next unless status == value
      raise GoogleMapsGeocoder.send(:error_class_name, key), message
    end
  end

  def logger
    @logger ||= Logger.new STDERR
  end

  def parse_address_component_type(type, name = 'long_name')
    address_component = @json['results'][0]['address_components'].detect do |ac|
      ac['types'] && ac['types'].include?(type)
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
    "#{parse_address_component_type('street_number')} "\
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

  def query_url(query)
    "#{GOOGLE_API_URI}?address=#{Rack::Utils.escape query}&sensor=false"\
    "#{api_key}"
  end

  def set_attributes_from_json
    ALL_ADDRESS_SEGMENTS.each do |segment|
      instance_variable_set :"@#{segment}", send("parse_#{segment}")
    end
  end
end
