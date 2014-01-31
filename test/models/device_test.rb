require 'test_helper'

class DeviceTest < ActiveSupport::TestCase
  describe Device do
    setup do
      @device = Device.new
      @test_xml = File.open(File.expand_path('test/fixtures/n2620G.xml', Rails.root))
      @test_html = File.open(File.expand_path('test/fixtures/n2620G.html', Rails.root))
    end
    it "normalizes mac address" do
      mac = "01:02:03:04:05:06"
      @device.mac_address = mac
      @device._mac_address.must_equal "010203040506"
      @device.mac_address.must_equal mac
    end
    
    describe "Loading attributes from XML" do
      it "takes an xmlfile" do
        @device.xmlfile = File.open(@test_xml)
        @device.xmlfile.must_be_kind_of CarrierWave
      end
    end
  end
end