class PushTask
  attr_accessor :resource
  
  def initialize(device)
    @device = device
    @site = device.site
    @resource = RestClient::Resource.new("http://#{@site.pxe}")
  end
  
  def exists?
    begin
      !!(check =~ /#{@device.fmac_address}/)
    rescue RuntimeError
      return false
    end
  end
  
  def check
    result = nil
    Net::SSH.start('10.5.1.65', 'root') do |ssh|
      result = ssh.exec!("ls /srv/tftpboot/pxelinux.cfg")
    end
    result
  end
  
  def schedule(job)
  end
  
  def delete
  end
  
  # private
  # 
  # def parse(resp)
  #   JSON.parse(resp).symbolize_keys
  # end
end