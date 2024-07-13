# GoogleMapsGeocoder

[![Build status](https://github.com/FoveaCentral/google_maps_geocoder/workflows/test/badge.svg)](https://github.com/FoveaCentral/google_maps_geocoder/actions/workflows/test.yml)
[![Code Climate](https://codeclimate.com/github/FoveaCentral/google_maps_geocoder.svg)](https://codeclimate.com/github/FoveaCentral/google_maps_geocoder)
[![Coverage Status](https://coveralls.io/repos/github/FoveaCentral/google_maps_geocoder/badge.svg?branch=master)](https://coveralls.io/github/FoveaCentral/google_maps_geocoder?branch=master)
[![CII Best Practices](https://bestpractices.coreinfrastructure.org/projects/92/badge)](https://bestpractices.coreinfrastructure.org/projects/92)
[![Gem Version](https://badge.fury.io/rb/google_maps_geocoder.svg)](https://rubygems.org/gems/google_maps_geocoder)

A simple Plain Old Ruby Object wrapper for geocoding with Google Maps.

## Installation

1. Set your Google Maps API key, which Google now requires, as an environment variable:

    ```bash
    export GOOGLE_MAPS_API_KEY=[your key]
    ```

2. Add `GoogleMapsGeocoder` to your Gemfile and run `bundle`:

    ```ruby
    gem 'google_maps_geocoder'
    ```

    Or try it out in `irb` with:

    ```ruby
    require './lib/google_maps_geocoder/google_maps_geocoder'
    ```

### Security note

`GoogleMapsGeocoder` is cryptographically signed. To insure the gem you install hasn’t been tampered with, add my public key as a trusted certificate and then install:

```sh
gem cert --add <(curl -Ls https://raw.github.com/FoveaCentral/google_maps_geocoder/master/certs/ivanoblomov.pem)
gem install google_maps_geocoder -P HighSecurity
```

## Ready to Go in One Step

```ruby
chez_barack = GoogleMapsGeocoder.new '1600 Pennsylvania DC'
```

## Usage

Get the complete, formatted address:

```ruby
chez_barack.formatted_address
 => "1600 Pennsylvania Avenue Northwest, President's Park, Washington, DC 20500, USA"
```

...standardized name of the city:

```ruby
chez_barack.city
 => "Washington"
```

...full name of the state or region:

```ruby
chez_barack.state_long_name
 => "District of Columbia"
```

...standard abbreviation for the state/region:

```ruby
chez_barack.state_short_name
 => "DC"
```

## API

The complete, hopefully self-explanatory, API is:

* `GoogleMapsGeocoder#city`
* `GoogleMapsGeocoder#country_long_name`
* `GoogleMapsGeocoder#country_short_name`
* `GoogleMapsGeocoder#county`
* `GoogleMapsGeocoder#exact_match?`
* `GoogleMapsGeocoder#formatted_address`
* `GoogleMapsGeocoder#formatted_street_address`
* `GoogleMapsGeocoder#lat`
* `GoogleMapsGeocoder#lng`
* `GoogleMapsGeocoder#partial_match?`
* `GoogleMapsGeocoder#postal_code`
* `GoogleMapsGeocoder#state_long_name`
* `GoogleMapsGeocoder#state_short_name`

For compatibility with [Geocoder](https://github.com/alexreisner/geocoder), the following aliases are also available:

* `GoogleMapsGeocoder#address`
* `GoogleMapsGeocoder#coordinates`
* `GoogleMapsGeocoder#country`
* `GoogleMapsGeocoder#country_code`
* `GoogleMapsGeocoder#latitude`
* `GoogleMapsGeocoder#longitude`
* `GoogleMapsGeocoder#state`
* `GoogleMapsGeocoder#state_code`

## Documentation

Complete RDoc documentation is available at [RubyDoc.info](https://www.rubydoc.info/gems/google_maps_geocoder).

## [Contributing to GoogleMapsGeocoder](.github/CONTRIBUTING.md)

## Copyright

Copyright © 2011-2024 Roderick Monje. See [LICENSE.txt](LICENSE.txt) for further details.
