# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name = 'google_maps_geocoder'
  s.version = '1.0.1'
  s.licenses = ['MIT']
  s.summary = 'A simple PORO wrapper for geocoding with Google Maps.'
  s.description = 'Geocode a location without worrying about parsing Google ' \
                  "Maps' response. GoogleMapsGeocoder wraps it in a plain-old " \
                  'Ruby object.'
  s.homepage = 'https://github.com/FoveaCentral/google_maps_geocoder'
  s.authors = ['Roderick Monje']
  s.email = 'rod@foveacentral.com'

  s.add_dependency 'rack'

  s.files = ['lib/google_maps_geocoder.rb']
  s.required_ruby_version = '>= 3.1'
  s.metadata['rubygems_mfa_required'] = 'true'
end
