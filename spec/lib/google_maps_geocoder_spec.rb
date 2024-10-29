# Copyright the GoogleMapsGeocoder contributors.
# SPDX-License-Identifier: MIT
# frozen_string_literal: true

require "#{File.dirname(__FILE__)}/../spec_helper"
# rubocop:disable Metrics/BlockLength
RSpec.describe GoogleMapsGeocoder do
  describe '#new' do
    context 'when API key is valid' do
      context 'with "White House"' do
        subject(:geocoder) do
          GoogleMapsGeocoder.new('White House')
        rescue SocketError
          pending 'waiting for a network connection'
        rescue GoogleMapsGeocoder::GeocodingError => e
          raise if e.json['status'] == 'REQUEST_DENIED'

          pending 'waiting for query limit to pass'
        end

        it { should be_partial_match }
        it { should_not be_exact_match }

        describe '#formatted_street_address' do
          it { expect(geocoder.formatted_street_address).to eq '1600 Pennsylvania Avenue Northwest' }
        end
        describe '#city' do
          it { expect(geocoder.city).to eq 'Washington' }
        end
        describe '#state_long_name' do
          it { expect(geocoder.state_long_name).to eq 'District of Columbia' }
        end
        describe '#state_short_name' do
          it { expect(geocoder.state_short_name).to eq 'DC' }
        end
        describe '#postal_code' do
          it { expect(geocoder.postal_code).to eq '20500' }
        end
        describe '#country_short_name' do
          it { expect(geocoder.country_short_name).to eq 'US' }
        end
        describe '#country_long_name' do
          it { expect(geocoder.country_long_name).to eq 'United States' }
        end
        describe '#formatted_address' do
          it { expect(geocoder.formatted_address).to match(/1600 Pennsylvania Avenue NW, Washington, DC 20500, USA/) }
        end
        describe '#lat' do
          it { expect(geocoder.lat).to be_within(0.005).of(38.8976633) }
        end
        describe '#lat' do
          it { expect(geocoder.lng).to be_within(0.005).of(-77.0365739) }
        end

        context 'when using Geocoder API' do
          describe '#address' do
            it { expect(geocoder.address).to eq subject.formatted_address }
          end
          describe '#coordinates' do
            it { expect(geocoder.coordinates).to eq [subject.lat, subject.lng] }
          end
          describe '#country' do
            it { expect(geocoder.country).to eq subject.country_long_name }
          end
          describe '#country_code' do
            it { expect(geocoder.country_code).to eq subject.country_short_name }
          end
          describe '#latitude' do
            it { expect(geocoder.latitude).to eq subject.lat }
          end
          describe '#longitude' do
            it { expect(geocoder.longitude).to eq subject.lng }
          end
          describe '#state' do
            it { expect(geocoder.state).to eq subject.state_long_name }
          end
          describe '#state_code' do
            it { expect(geocoder.state_code).to eq subject.state_short_name }
          end
        end
      end
    end

    context 'when API key is invalid' do
      around do |example|
        original_key = ENV['GOOGLE_MAPS_API_KEY']
        ENV['GOOGLE_MAPS_API_KEY'] = 'invalid_key'
        example.run
        ENV['GOOGLE_MAPS_API_KEY'] = original_key
      end

      subject(:geocoder) do
        GoogleMapsGeocoder.new('nowhere that comes to mind')
      rescue SocketError
        pending 'waiting for a network connection'
      end

      it { expect { geocoder }.to raise_error GoogleMapsGeocoder::GeocodingError }
    end
  end
end
# rubocop:enable Metrics/BlockLength
