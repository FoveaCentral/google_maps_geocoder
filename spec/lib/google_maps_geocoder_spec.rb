require File.dirname(__FILE__) + '/../spec_helper'

describe GoogleMapsGeocoder do
  before(:all) do
    begin
      @exact_match   = GoogleMapsGeocoder.new('837 Union Street Brooklyn NY')
      @partial_match = GoogleMapsGeocoder.new('1600 Pennsylvania Washington')
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

  context 'with "837 Union Street Brooklyn NY"' do
    subject { @exact_match }
    it { expect(subject).to be_exact_match }

    context 'address' do
      it { expect(subject.formatted_street_address).to eq '837 Union Street' }
      it { expect(subject.city).to eq 'Brooklyn' }
      it { expect(subject.county).to match(/Kings/) }
      it { expect(subject.state_long_name).to eq 'New York' }
      it { expect(subject.state_short_name).to eq 'NY' }
      it { expect(subject.postal_code).to match(/112[0-9]{2}/) }
      it { expect(subject.country_short_name).to eq 'US' }
      it { expect(subject.country_long_name).to eq 'United States' }
      it do
        expect(subject.formatted_address)
          .to match(/837 Union St, Brooklyn, NY 112[0-9]{2}, USA/)
      end
    end

    context 'coordinates' do
      it { expect(subject.lat).to be_within(0.005).of(40.6748151) }
      it { expect(subject.lng).to be_within(0.005).of(-73.9760302) }
    end
  end

  context 'with "1600 Pennsylvania Washington"' do
    subject { @partial_match }
    it { should be_partial_match }

    context 'address' do
      it do
        expect(subject.formatted_street_address)
          .to eq '1600 Pennsylvania Avenue Southeast'
      end
      it { expect(subject.city).to eq 'Washington' }
      it { expect(subject.state_long_name).to eq 'District of Columbia' }
      it { expect(subject.state_short_name).to eq 'DC' }
      it { expect(subject.postal_code).to match(/2000[0-9]/) }
      it { expect(subject.country_short_name).to eq 'US' }
      it { expect(subject.country_long_name).to eq 'United States' }
      it do
        expect(subject.formatted_address)
          .to match(/1600 Pennsylvania Ave SE, Washington, DC 20003, USA/)
      end
    end

    context 'coordinates' do
      it { expect(subject.lat).to be_within(0.005).of(38.8791981) }
      it { expect(subject.lng).to be_within(0.005).of(-76.9818437) }
    end
  end

  context "when ENV['GOOGLE_MAPS_API_KEY'] = 'INVALID_KEY'" do
    before { ENV['GOOGLE_MAPS_API_KEY'] = 'INVALID_KEY' }

    subject { @exact_match }

    it do
      expect(subject.send(:query_url, nil)).to eq(
        'https://maps.googleapis.com/maps/api/geocode/json?address='\
        '&sensor=false&key=INVALID_KEY'
      )
    end
  end

  context 'with google returns empty results' do
    let(:results_hash) { { 'results' => [] } }

    GoogleMapsGeocoder::ERROR_STATUSES.each do |key, value|
      it "raises #{key} error" do
        allow_any_instance_of(GoogleMapsGeocoder).to receive(:json_from_url)\
          .and_return results_hash.merge('status' => value)

        expect { GoogleMapsGeocoder.new('anything') }.to \
          raise_error(GoogleMapsGeocoder.error_class_name(key))
      end
    end
  end
end
