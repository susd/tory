require 'test_helper'

class DeviceTest < ActiveSupport::TestCase
  describe Device do
    setup do
      @device = Device.new
    end
    
    describe "Formatting attributes" do
      it "normalizes mac address" do
        mac = "01:02:03:04:05:06"
        @device.mac_address = mac
        @device.attributes['mac_address'].must_equal "010203040506"
        @device.mac_address.must_equal mac
      end
    end
    
    describe "Loading attributes from XML" do
      before do
        @test_xml = File.open(File.expand_path('test/fixtures/n2620G.xml', Rails.root))
        @device.xmlfile = File.open(@test_xml)
      end
      it "mounts an xmlfile with CarrierWave" do
        @device.xmlfile.must_be_kind_of XmlUploader
      end
      
      it "extracts the cpu product" do
        @device.extract_cpu!
        @device.cpu.must_equal "Intel(R) Celeron(R) CPU 887 @ 1.50GHz"
      end
      
      it "extracts the cpu_speed" do
        @device.extract_speed!
        @device.cpu_speed.must_equal 1500
      end
      
      it "extracts the ram size" do
        @device.extract_ram!
        @device.ram.must_equal "2.0 GB"
      end
      
      it "extracts the memory bank information" do
        @device.extract_banks!
        @device.save
        @device.reload
        @device.banks.must_equal({'0' => {'id' => 'bank:0', 'size' => '2.0 GB'}, '1' => 'empty' })
      end
      
      it "extracts the make" do
        @device.extract_make!
        @device.make.must_equal "Acer"
      end
      
      it "extracts the product" do
        @device.extract_product!
        @device.product.must_equal "Veriton N2620G ()"
      end
      
      it "extracts the serial" do
        @device.extract_serial!
        @device.serial.must_equal "DTVFGAA002252057D49200"
      end
      
      it "extracts the uuid" do
        @device.extract_uuid!
        @device.uuid.must_equal "D02788DD-EB2D-2012-1227-152554000000"
      end
      
    end
    
    describe "Device states" do
      it "Can be retired" do
        @device.retire
        assert @device.retired?
      end
    end
  end
end