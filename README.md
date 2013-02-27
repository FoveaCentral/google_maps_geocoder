# GoogleMapsGeocoder [![Code Climate](https://codeclimate.com/github/ivanoblomov/google_maps_geocoder.png)](https://codeclimate.com/github/ivanoblomov/google_maps_geocoder) [![Build Status](https://secure.travis-ci.org/ivanoblomov/google_maps_geocoder.png)](http://travis-ci.org/ivanoblomov/google_maps_geocoder) [![Dependency Status](https://gemnasium.com/ivanoblomov/google_maps_geocoder.png)](https://gemnasium.com/ivanoblomov/google_maps_geocoder)

A simple PORO wrapper for geocoding with Google Maps.

== Installation

In <b>Rails 3</b>, add this to your Gemfile and run the +bundle+ command.

```ruby
  gem 'google_maps_geocoder'
```

In <b>Rails 2</b>, add this to your environment.rb file.

```ruby
  config.gem 'google_maps_geocoder'
```

## Ready to Go in One Step

```ruby
chez_barack = GoogleMapsGeocoder.new '1600 Pennsylvania Washington'
```

## Usage

Get the complete, formatted address:

```ruby
chez_barack.formatted_address
```

...standardized name of the city:

```ruby
chez_barack.city
```

...full name of the state or region:

```ruby
chez_barack.state_long_name
```

...standard abbreviation for the state/region:

```ruby
chez_barack.state_short_name
```

## API

The complete, hopefully self-explanatory, API is:

* city
* country_long_name
* country_short_name
* county
* exact_match?
* formatted_address
* formatted_street_address
* lat
* lng
* partial_match?
* postal_code
* state_long_name
* state_short_name

## Contributing to google_maps_geocoder

* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2011 Roderick Monje. See LICENSE.txt for further details.
