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
      return resp[:message] == 'task active'
    rescue RestClient::ResourceNotFound
      return false
    end
  end
  
  def check
    begin
      parse @resource["/check/#{@device.mac_address}"].get
    rescue Errno::ECONNREFUSED
      parse( {message: 'Remote connection refused'}.to_json )
    end
  end
  
  def schedule(job)
    begin
      data = {
        mac_address: @device.mac_address,
        image: @device.image.name
      }
      resp = @resource[job].post data
      parse resp
    rescue Errno::ECONNREFUSED
      parse( {message: 'Remote connection refused'}.to_json )
    end
  end
  
  def delete
    begin
      parse @resource["/finished/#{@device.mac_address}"].delete
    rescue RestClient::ResourceNotFound
      #If there's no task, then pretend it was deleted.
      #TODO: Check first and act accordingly.
      parse({message: 'task deleted'}.to_json)
    rescue Errno::ECONNREFUSED
      #TODO: Get this message to the user somehow
      parse( {message: 'Remote connection refused'}.to_json )
    end
  end
  
  private
  
  def parse(resp)
    JSON.parse(resp).symbolize_keys
  end
end