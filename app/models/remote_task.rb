class RemoteTask
  attr_accessor :resource
  
  def initialize(device)
    @device = device
    @site = device.site
    @resource = RestClient::Resource.new("http://#{@site.pxe}")
  end
  
  def exists?
    begin
      resp = JSON.parse check
      return resp[:message] == 'active task'
    rescue RestClient::ResourceNotFound
      return false
    end
  end
  
  def check
    @resource["/check/#{@device.mac_address}"].get
  end
  
  def schedule(job)
    data = {
      mac_address: @device.mac_address,
      image: @device.image.name
    }
    @resource[job].post data
  end
end