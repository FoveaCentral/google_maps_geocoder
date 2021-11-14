Closes: #

# Goal
What problem does this pull request solve? This should be close to the goal of the issue this pull request addresses.

# Approach
1. **Describe, in numbered steps, the approach you chose** to solve the above problem.
    1. This will help code reviewers get oriented quickly.
    2. It will also document for future maintainers exactly what changed (and why) when this PR was merged.
2. **Add specs** that either *reproduce the bug* or *cover the new feature*. In the former's case, *make sure it fails without the fix!*
3. Document any new public methods using standard RDoc syntax, or update the existing RDoc for any modified public methods. As an example, see the RDoc for `GoogleMapsGeocoder.new`:

```ruby
  # Geocodes the specified address and wraps the results in a GoogleMapsGeocoder
  # object.
  #
  # @param address [String] a geocodable address
  # @return [GoogleMapsGeocoder] the Google Maps result for the specified
  #   address
  # @example
  #   chez_barack = GoogleMapsGeocoder.new '1600 Pennsylvania DC'
  def initialize(address)
    @json = address.is_a?(String) ? google_maps_response(address) : address
    status = @json && @json['status']
    raise RuntimeError if status == 'OVER_QUERY_LIMIT'
    raise GeocodingError, @json if @json.blank? || status != 'OK'

    set_attributes_from_json
    Logger.new($stderr).info('GoogleMapsGeocoder') do
      "Geocoded \"#{address}\" => \"#{formatted_address}\""
    end
  end
```

Signed-off-by: YOUR NAME <YOUR.EMAIL@EXAMPLE.COM>
