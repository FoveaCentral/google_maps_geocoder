# frozen_string_literal: true

require 'simplecov'
require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  warn e.message
  warn 'Run `bundle install` to install missing gems'
  exit e.status_code
end
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'google_maps_geocoder/google_maps_geocoder'
# silence output
RSpec.configure do |config|
  original_stderr = $stderr
  original_stdout = $stdout
  config.before(:context) do
    # Redirect stderr and stdout
    $stderr = File.open(File::NULL, 'w')
    $stdout = File.open(File::NULL, 'w')
  end
  config.after(:context) do
    $stderr = original_stderr
    $stdout = original_stdout
  end
end
