# Copyright the GoogleMapsGeocoder contributors.
# SPDX-License-Identifier: MIT
# frozen_string_literal: true

require "#{File.dirname(__FILE__)}/../spec_helper"
# rubocop:disable Metrics/BlockLength
RSpec.describe GoogleMapsGeocoder do
  describe '#new' do
    context 'with "White House"' do
      subject(:geocoder) do
        GoogleMapsGeocoder.new('White House')
      rescue SocketError
        pending 'waiting for a network connection'
      rescue GoogleMapsGeocoder::GeocodingError => e
        if e.json['status'] == 'REQUEST_DENIED'
          raise e
        else
          pending 'waiting for query limit to pass'
        end
      end

      it { should be_partial_match }
      it { should_not be_exact_match }

      context 'address' do
        it do
          expect(geocoder.formatted_street_address)
            .to eq '1600 Pennsylvania Avenue Northwest'
        end
        it { expect(geocoder.city).to eq 'Washington' }
        it { expect(geocoder.state_long_name).to eq 'District of Columbia' }
        it { expect(geocoder.state_short_name).to eq 'DC' }
        it { expect(geocoder.postal_code).to eq '20500' }
        it { expect(geocoder.country_short_name).to eq 'US' }
        it { expect(geocoder.country_long_name).to eq 'United States' }
        it do
          expect(geocoder.formatted_address)
            .to match(/1600 Pennsylvania Avenue NW, Washington, DC 20500, USA/)
        end
      end

      context 'coordinates' do
        it { expect(geocoder.lat).to be_within(0.005).of(38.8976633) }
        it { expect(geocoder.lng).to be_within(0.005).of(-77.0365739) }
      end

      context 'Geocoder API' do
        it { expect(geocoder.address).to eq subject.formatted_address }
        it { expect(geocoder.coordinates).to eq [subject.lat, subject.lng] }
        it { expect(geocoder.country).to eq subject.country_long_name }
        it { expect(geocoder.country_code).to eq subject.country_short_name }
        it { expect(geocoder.latitude).to eq subject.lat }
        it { expect(geocoder.longitude).to eq subject.lng }
        it { expect(geocoder.state).to eq subject.state_long_name }
        it { expect(geocoder.state_code).to eq subject.state_short_name }
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

      it do
        expect { geocoder }.to raise_error GoogleMapsGeocoder::GeocodingError,
                                           'REQUEST_DENIED'
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
