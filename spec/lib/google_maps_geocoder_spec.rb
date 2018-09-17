require File.dirname(__FILE__) + '/../spec_helper'
# rubocop:disable Metrics/BlockLength
describe GoogleMapsGeocoder do
  before(:all) do
    begin
      @exact_match = GoogleMapsGeocoder.new('White House')
    rescue SocketError
      @no_network  = true
    rescue RuntimeError
      @query_limit = true
    end
  end

  before(:each) do
    pending 'waiting for a network connection' if @no_network
    pending 'waiting for query limit to pass' if @query_limit
  end

  describe '#new' do
    context 'with "White House"' do
      subject { @exact_match }

      it { should be_exact_match }

      context 'address' do
        it do
          expect(subject.formatted_street_address)
            .to eq '1600 Pennsylvania Avenue Northwest'
        end
        it { expect(subject.city).to eq 'Washington' }
        it { expect(subject.state_long_name).to eq 'District of Columbia' }
        it { expect(subject.state_short_name).to eq 'DC' }
        it { expect(subject.postal_code).to eq '20500' }
        it { expect(subject.country_short_name).to eq 'US' }
        it { expect(subject.country_long_name).to eq 'United States' }
        it do
          expect(subject.formatted_address)
            .to match(/1600 Pennsylvania Ave NW, Washington, DC 20500, USA/)
        end
      end
      context 'coordinates' do
        it { expect(subject.lat).to be_within(0.005).of(38.8976633) }
        it { expect(subject.lng).to be_within(0.005).of(-77.0365739) }
      end
    end
    context 'with an invalid address' do
      subject { GoogleMapsGeocoder.new('Four score and seven years ago') }

      it do
        expect { subject }.to raise_error GoogleMapsGeocoder::GeocodingError,
                                          'ZERO_RESULTS'
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
