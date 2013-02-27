require 'active_support'
require 'logger'
require 'net/http'
require 'rack'

class GoogleMapsGeocoder
  # Returns the complete formatted address with standardized abbreviations.
  attr_reader :formatted_address
  # Returns the formatted street address with standardized abbreviations.
  attr_reader :formatted_street_address
  # Self-explanatory
  attr_reader :city, :country_long_name, :country_short_name, :county, :lat, :lng, :postal_code, :state_long_name, :state_short_name

  # Instance Methods: Overrides ====================================================================

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
  #     => "1600 Pennsylvania Avenue Northwest, President's Park, Washington, DC 20500, USA"
  def initialize data
    @json = data.is_a?(String) ? json_from_url(data) : data
		raise "Geocoding \"#{data}\" exceeded query limit! Google returned...\n#{@json.inspect}" if @json.blank? || @json['status'] != 'OK'
    set_attributes_from_json
    logger = Logger.new STDERR
    logger.info('GoogleMapsGeocoder') { "Geocoded \"#{data}\" => \"#{self.formatted_address}\"" }
  end

  # Instance Methods ===============================================================================

  # Returns true if the address Google returns is an exact match.
  #
  # ==== Examples
  #
  #    white_house = GoogleMapsGeocoder.new('1600 Pennsylvania Ave')
  #    white_house.exact_match?
  #     => true
  def exact_match?
    ! self.partial_match?
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

  def json_from_url url
    response = Net::HTTP.get_response(URI.parse "http://maps.googleapis.com/maps/api/geocode/json?address=#{Rack::Utils.escape(url)}&sensor=false")
    ActiveSupport::JSON.decode response.body
  end

  def parse_address_component_type(type, name='long_name')
    _address_component = @json['results'][0]['address_components'].detect{ |ac| ac['types'] && ac['types'].include?(type) }
    _address_component && _address_component[name]
  end

  def parse_city
    parse_address_component_type('sublocality') || parse_address_component_type('locality')
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
    "#{parse_address_component_type('street_number')} #{parse_address_component_type('route')}"
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
    @city, @country_short_name, @country_long_name, @county, @formatted_address, @formatted_street_address, @lat, @lng, @postal_code, @state_long_name, @state_short_name = parse_city, parse_country_short_name, parse_country_long_name, parse_county, parse_formatted_address, parse_formatted_street_address, parse_lat, parse_lng, parse_postal_code, parse_state_long_name, parse_state_short_name
  end
end