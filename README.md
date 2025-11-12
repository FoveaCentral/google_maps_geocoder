# GoogleMapsGeocoder

[![Build status](https://github.com/FoveaCentral/google_maps_geocoder/workflows/test/badge.svg)](https://github.com/FoveaCentral/google_maps_geocoder/actions/workflows/test.yml)
[![Maintainability](https://qlty.sh/gh/FoveaCentral/projects/google_maps_geocoder/maintainability.svg)](https://qlty.sh/gh/FoveaCentral/projects/google_maps_geocoder)[![Coverage Status](https://coveralls.io/repos/github/FoveaCentral/google_maps_geocoder/badge.svg?branch=master)](https://coveralls.io/github/FoveaCentral/google_maps_geocoder?branch=master)
[![OpenSSF Best Practices](https://www.bestpractices.dev/projects/92/badge)](https://www.bestpractices.dev/projects/92)
[![OpenSSF Scorecard](https://api.scorecard.dev/projects/github.com/FoveaCentral/google_maps_geocoder/badge)](https://scorecard.dev/viewer/?uri=github.com/FoveaCentral/google_maps_geocoder)
[![Gem Version](https://badge.fury.io/rb/google_maps_geocoder.svg)](https://rubygems.org/gems/google_maps_geocoder)

A simple Plain Old Ruby Object wrapper for geocoding with Google Maps, `GoogleMapsGeocoder` gives you all its geocoding functionality with these advantages:
  * *easy to use* in **[only one step](#ready-to-go-in-one-step)**
  * **[fully documented](https://www.rubydoc.info/gems/google_maps_geocoder)** with *[complete test coverage](https://coveralls.io/github/FoveaCentral/google_maps_geocoder)*
  * *lightweight* at **[only 10.5 K](https://rubygems.org/gems/google_maps_geocoder)** as a gem (that's just over a tenth the size of [Geocoder](https://rubygems.org/gems/geocoder))
  * only a **[single dependency](google_maps_geocoder.gemspec)**, the commonly used [Rack](https://github.com/rack/rack)


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
    require './lib/google_maps_geocoder'
    ```

### Security note

`GoogleMapsGeocoder` is cryptographically signed. To insure the gem you install hasn’t been tampered with, add my public key as a trusted certificate and then install:

```sh
gem cert --add <(curl -Ls https://raw.github.com/FoveaCentral/google_maps_geocoder/master/certs/ivanoblomov.pem)
gem install google_maps_geocoder -P HighSecurity
```

## Ready to Go in One Step

```ruby
chez_barack = GoogleMapsGeocoder.new 'White House'
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

Copyright © 2011-2025 Roderick Monje. See [LICENSE.txt](LICENSE.txt) for further details.
