require File.dirname(__FILE__) + '/../spec_helper'

describe GoogleMapsGeocoder do
  before(:all) do
    begin
      @exact_match = GoogleMapsGeocoder.new('837 Union St Brooklyn NY')
      @partial_match = GoogleMapsGeocoder.new('1600 Pennsylvania Washington')
    rescue SocketError
      @no_network = true
    rescue RuntimeError
      @query_limit = true
    end
  end

  before(:each) do
    pending 'waiting for a network connection', :if => @no_network
    pending 'waiting for query limit to pass', :if => @query_limit
  end

  context 'with "837 Union St Brooklyn NY"' do
    subject { @exact_match }
    specify { should be_exact_match }

    context 'address' do
      specify { subject.formatted_street_address.should == '837 Union St' }
      specify { subject.city.should == 'Brooklyn' }
      specify { subject.county.should == 'Kings' }
      specify { subject.state_long_name.should == 'New York' }
      specify { subject.state_short_name.should == 'NY' }
      specify { subject.postal_code.should == '11215' }
      specify { subject.country_short_name.should == 'US' }
      specify { subject.country_long_name.should == 'United States' }
      specify { subject.formatted_address.should == '837 Union St, Brooklyn, NY 11215, USA' }
    end

    context 'coordinates' do
      specify { subject.lat.should be_within(0.005).of(40.6748151) }
      specify { subject.lng.should be_within(0.005).of(-73.9760302) }
    end
  end

  context 'with "1600 Pennsylvania Washington"' do
    subject { @partial_match }
    specify { should be_partial_match }

    context 'address' do
      specify { subject.formatted_street_address.should == '1600 Pennsylvania Ave NW' }
      specify { subject.city.should == 'Washington D.C.' }
      specify { subject.state_long_name.should == 'District of Columbia' }
      specify { subject.state_short_name.should == 'DC' }
      specify { subject.postal_code.should == '20500' }
      specify { subject.country_short_name.should == 'US' }
      specify { subject.country_long_name.should == 'United States' }
      specify { subject.formatted_address.should == '1600 Pennsylvania Ave NW, Washington D.C., DC 20500, USA' }
   end

   context 'coordinates' do
      specify { subject.lat.should be_within(0.005).of(38.8976964) }
      specify { subject.lng.should be_within(0.005).of(-77.0365191) }
   end
  end
end
