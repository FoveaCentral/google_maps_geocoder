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
  config.before(:example, silence_logger: true) do
    allow_any_instance_of(Logger).to receive(:info).and_return true
    allow_any_instance_of(Logger).to receive(:error).and_return true
  end

  config.after(:example) do
    allow_any_instance_of(Logger).to receive(:info).and_call_original
    allow_any_instance_of(Logger).to receive(:error).and_call_original
  end
end
