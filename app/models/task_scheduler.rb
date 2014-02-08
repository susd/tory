class TaskScheduler
  
  def initialize(device)
    @device = device
    @site = device.site
    @resource = RestClient::Resource.new("http://#{@site.pxe}")
  end
  
  def check(device)
    @resource['check'].get @device.mac_address
  end
  
  def schedule(job)
    data = {
      mac_address: @device.mac_address
    }
    @resource[job].post data
  end
end