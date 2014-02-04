require 'test_helper'

class ApiTest < ActionDispatch::IntegrationTest
  def setup
    @device = Device.create(mac_address: SecureRandom.hex(6), site: sites(:one))
    @test_xml = File.open(File.expand_path('test/fixtures/n2620G.xml', Rails.root))
    @test_html = File.open(File.expand_path('test/fixtures/n2620G.html', Rails.root))
    @device_params = { xml_file: @test_xml, html_file: @test_html, ip_addr: '10.10.1.85' }
    @site = sites(:one)
  end
  
  def teardown
    Device.destroy_all
  end
  
  test 'searching without params' do
    get '/inventory.json'
    assert_response :success
    assert_equal 0, assigns(:devices).count
  end
  
  test "search with params" do
    get "/inventory.json?mac_address=#{@device.mac_address}"
    assert_response :success
    assert_equal 1, assigns(:devices).count
  end
  
  test "post new to inventory" do
    count = Device.count
    post '/inventory.json', { mac_address: '112233445566', device: @device_params }
    assert_response :success
    assert_equal (count+1), Device.count
  end
  
  test "post existing to inventory" do
    count = Device.count
    post '/inventory.json', { mac_address: @device.mac_address, device: @device_params }
    assert_response :success
    assert_equal count, Device.count
  end
  
  test "Site assignment on creation" do
    post '/inventory.json', { mac_address: '000102030405', device: @device_params }
    assert_equal 10, assigns(:device).site.code
  end
  
  private
  
  def new_mac
    SecureRandom.hex(6)
  end
  
end
