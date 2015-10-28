require File.expand_path '../lib/google_maps_geocoder/version', __FILE__
Gem::Specification.new do |s|
  s.name = 'google_maps_geocoder'
  s.version = GoogleMapsGeocoder::VERSION.dup
  s.summary = 'A simple PORO wrapper for geocoding with Google Maps.'
  s.description = 'Geocode a location without worrying about parsing Google '\
                  "Maps' response. GoogleMapsGeocoder wraps it in a plain-old "\
                  'Ruby object.'
  s.homepage = 'http://github.com/ivanoblomov/google_maps_geocoder'
  s.authors = ['Roderick Monje']

  s.add_development_dependency 'coveralls', '>= 0'
  s.add_development_dependency 'rake', '>= 0'
  s.add_development_dependency 'rspec', '>= 0'
  s.add_development_dependency 'rubocop', '>= 0'

  s.add_runtime_dependency 'activesupport', '>= 0'
  s.add_runtime_dependency 'rack', '>= 0'

  s.files       = `git ls-files`.split "\n"
  s.test_files  = `git ls-files -- {test,spec,features}/*`.split "\n"
  s.executables = `git ls-files -- bin/*`.split("\n")
    .map { |f| File.basename f }
  s.require_paths = ['lib']
end
