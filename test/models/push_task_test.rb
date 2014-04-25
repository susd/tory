require 'test_helper'

class PushTaskTest < ActiveSupport::TestCase
  
  before do
    @device = devices(:one)
    @ptask = PushTask.new(@device)
  end
  
  test "Deploy matches correct output" do
    assert_equal deploy_output, @ptask.deploy_template
  end
  
  test "Upload matches correct output" do
    assert_equal upload_output, @ptask.upload_template
  end
  
  
  private
  
  def deploy_output
    %Q{DEFAULT tory-deploy
LABEL tory-deploy
  kernel zilla/live/vmlinuz
  append initrd=zilla/live/initrd.img boot=live config noswap edd=on nomodeset noprompt nolocales keyboard-layouts=NONE ocs_live_batch=yes vga=788 ip=frommedia nosplash i915.blacklist=yes radeonhd.blacklist=yes nouveau.blacklist=yes vmwgfx.blacklist=yes fetch=tftp://10.10.1.4/zilla/live/filesystem.squashfs ocs_prerun="mount -t nfs 10.10.1.4:/images/dev /home/partimag" ocs_postrun="wget http://tory.saugususd.org/tasks/001122334455/finish" ocs_postrun1="sudo reboot" ocs_live_run="/usr/sbin/ocs-sr -e1 auto -e2 -hn1 pc -r -j2 -b -p true restoredisk my-image-file sda"}
  end
  
  def upload_output
    %Q{DEFAULT tory-upload
LABEL tory-upload
  kernel zilla/live/vmlinuz
  append initrd=zilla/live/initrd.img boot=live config noswap edd=on nomodeset noprompt nolocales keyboard-layouts=NONE ocs_live_batch=yes vga=788 ip=frommedia nosplash i915.blacklist=yes radeonhd.blacklist=yes nouveau.blacklist=yes vmwgfx.blacklist=yes fetch=tftp://10.10.1.4/zilla/live/filesystem.squashfs ocs_prerun="mount -t nfs 10.10.1.4:/images/dev /home/partimag" ocs_postrun="wget http://tory.saugususd.org/tasks/001122334455/finish" ocs_postrun1="sudo reboot" ocs_live_run="/usr/sbin/ocs-sr -q2 -c -j2 -ntfs-ok -z1p -i 2000000 -p true savedisk my-image-file sda"}
  end
end