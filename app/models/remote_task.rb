class RemoteTask
  attr_accessor :resource
  
  def initialize(device)
    @device = device
    @site = device.site
    @resource = RestClient::Resource.new("http://#{@site.pxe}")
  end
  
  def exists?
    begin
      resp = check
      return resp[:message] == 'active task'
    rescue RestClient::ResourceNotFound
      return false
    end
  end
  
  def check
    parse @resource["/check/#{@device.mac_address}"].get
  end
  
  def schedule(job)
    data = {
      mac_address: @device.mac_address,
      image: @device.image.name
    }
    resp = @resource[job].post data
    parse resp
  end
  
  def delete
    parse @resource["/finished/#{@device.mac_address}"].delete
  end
  
  private
  
  def parse(resp)
    JSON.parse(resp).symbolize_keys
  end
end