require 'net/ssh'
require 'net/sftp'

class PushTask
  attr_accessor :resource, :path, :pxe
  
  def initialize(device)
    @device = device
    @site = device.site
    @pxe = @site.pxe
    @user = 'pxe'
    @path = "/srv/tftpboot/pxelinux.cfg/#{@device.pxe_mac}"
    
    @app = 'tory.saugususd.org'
  end
  
  def exists?
    begin
      !!(check =~ /#{@device.pxe_mac}/)
    rescue RuntimeError
      return false
    end
  end
  
  def check
    result = nil
    Net::SSH.start(@pxe, @user) do |ssh|
      result = ssh.exec!("ls /srv/tftpboot/pxelinux.cfg")
    end
    result
  end
  
  def schedule(job)
    if job == :upload
      data = upload_template
    else
      data = deploy_template
    end
    
    response = nil
    
    Net::SFTP.start(@pxe, @user) do |sftp|
      sftp.file.open(@path, "w") do |f|
        f.puts data
      end
    end
  end
  
  def delete
    result = nil
    Net::SSH.start(@pxe, @user) do |ssh|
      result = ssh.exec!("rm /srv/tftpboot/pxelinux.cfg/#{@device.pxe_mac}")
    end
    if result.blank?
      return true
    else
      return false
    end
  end
  
  def deploy_template
    output = "DEFAULT tory-deploy\nLABEL tory-deploy\n"
    output << kernel_line
    output << deploy_kernel_args
  end
  
  def upload_template
    output = "DEFAULT tory-upload\nLABEL tory-upload\n"
    output << kernel_line
    output << upload_kernel_args
  end
  
  def kernel_line
    "  kernel zilla/live/vmlinuz\n"
  end
  
  def deploy_kernel_args
    args = common_args
    args << %Q{ ocs_live_run="/usr/sbin/ocs-sr -e1 auto -e2 -hn1 pc -r -j2 -b -p true restoredisk #{@device.image.file} sda"}
    args
  end
  
  def upload_kernel_args
    args = common_args
    args << %Q{ ocs_live_run="/usr/sbin/ocs-sr -q2 -c -j2 -ntfs-ok -z1p -i 2000000 -p true savedisk #{@device.image.file} sda"}
    args
  end
  
  def common_args
    args = "  append initrd=zilla/live/initrd.img boot=live config noswap edd=on nomodeset noprompt nolocales keyboard-layouts=NONE"
    args << " ocs_live_batch=yes vga=788 ip=frommedia nosplash i915.blacklist=yes radeonhd.blacklist=yes nouveau.blacklist=yes vmwgfx.blacklist=yes"
    args << %Q{ fetch=tftp://#{@site.storage}/zilla/live/filesystem.squashfs}
    args << %Q{ ocs_prerun="mount -t nfs #{@site.storage}:/images/dev /home/partimag"}
    args << %Q{ ocs_postrun="wget http://#{@app}/push_tasks/#{@device.attributes['mac_address']}/finish" ocs_postrun1="sudo shutdown"}
  end

end

# append initrd=zilla/live/initrd.img boot=live config noswap edd=on nomodeset noprompt nolocales keyboard-layouts=NONE ocs_live_run="/usr/sbin/ocs-sr -e1 auto -e2 -hn1 pc -r -j2 -b -p true restoredisk <%= @image %> sda" ocs_live_batch=yes vga=788 ip=frommedia nosplash i915.blacklist=yes radeonhd.blacklist=yes nouveau.blacklist=yes vmwgfx.blacklist=yes fetch=tftp://<%= @pxe %>/zilla/live/filesystem.squashfs ocs_prerun="mount -t nfs <%= @storage %>:/images/dev /home/partimag" ocs_postrun="wget http://<%= @app %>/tasks/<%= @mac %>/finish" ocs_postrun1="sudo reboot"