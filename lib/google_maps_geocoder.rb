require 'active_support'
require 'logger'
require 'net/http'
require 'rack'

# A simple PORO wrapper for geocoding with Google Maps.
class GoogleMapsGeocoder
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
  attr_reader :formatted_address
  # Returns the formatted street address with standardized abbreviations.
  attr_reader :formatted_street_address
  # Self-explanatory
  attr_reader(*GOOGLE_ADDRESS_SEGMENTS)

  # Instance Methods: Overrides ================================================

  # Geocodes the specified address and wraps the results in a geocoder object.
  #
  # ==== Attributes
  #
  # * +data+ - a geocodable address
  #
  # ==== Examples
  #
  #    white_house = GoogleMapsGeocoder.new('1600 Pennsylvania Washington')
  #    white_house.formatted_address
  #     => "1600 Pennsylvania Avenue Northwest, President's Park,
  #         Washington, DC 20500, USA"
  def initialize(data)
    @json = data.is_a?(String) ? json_from_url(data) : data
    fail "Geocoding \"#{data}\" exceeded query limit! Google returned...\n"\
         "#{@json.inspect}" if @json.blank? || @json['status'] != 'OK'
    set_attributes_from_json
    logger.info('GoogleMapsGeocoder') do
      "Geocoded \"#{data}\" => \"#{formatted_address}\""
    end
  end

  # Instance Methods ===========================================================

  # Returns true if the address Google returns is an exact match.
  #
  # ==== Examples
  #
  #    white_house = GoogleMapsGeocoder.new('1600 Pennsylvania Ave')
  #    white_house.exact_match?
  #     => true
  def exact_match?
    !self.partial_match?
  end

  # Returns true if the address Google returns isn't an exact match.
  #
  # ==== Examples
  #
  #    white_house = GoogleMapsGeocoder.new('1600 Pennsylvania Washington')
  #    white_house.exact_match?
  #     => false
  def partial_match?
    @json['results'][0]['partial_match'] == true
  end

  private

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
