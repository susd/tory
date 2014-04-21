class PushTask
  attr_accessor :resource
  
  def initialize(device)
    @device = device
    @site = device.site
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
    Net::SSH.start(device.site.pxe, 'root') do |ssh|
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