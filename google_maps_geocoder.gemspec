# frozen_string_literal: true

require File.expand_path('lib/google_maps_geocoder/version', __dir__)
Gem::Specification.new do |s|
  s.name = 'google_maps_geocoder'
  s.version = GoogleMapsGeocoder::VERSION.dup
  s.licenses = ['MIT']
  s.summary = 'A simple PORO wrapper for geocoding with Google Maps.'
  s.description = 'Geocode a location without worrying about parsing Google '\
                  "Maps' response. GoogleMapsGeocoder wraps it in a plain-old "\
                  'Ruby object.'
  s.homepage = 'https://github.com/GoogleMapsGeocoder/google_maps_geocoder'
  s.authors = ['Roderick Monje']
  s.cert_chain = ['certs/ivanoblomov.pem']
  s.email = 'rod@foveacentral.com'
  s.signing_key = File.expand_path('~/.ssh/gem-private_key.pem') if $PROGRAM_NAME =~ /gem\z/

  s.add_development_dependency 'rake', '>= 12.3.3', '~> 13.0'
  s.add_development_dependency 'rspec', '~> 3'
  s.add_development_dependency 'rubocop', '< 1.24'
  s.add_development_dependency 'rubocop-rake', '~> 0'
  s.add_development_dependency 'rubocop-rspec', '~> 2'
  s.add_development_dependency 'simplecov', '~> 0.18'
  s.add_development_dependency 'simplecov-lcov', '~> 0.8'

  s.add_runtime_dependency 'activesupport', '>= 4.1.11', '< 7.0'
  s.add_runtime_dependency 'rack', '>= 2.1.4', '< 2.3.0'

  s.files = `git ls-files`.split "\n"
  s.require_paths = ['lib']
  s.required_ruby_version = '>= 2.5'
end
