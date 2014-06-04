# == Schema Information
#
# Table name: sites
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  abbr       :string(255)
#  pxe        :string(255)
#  storage    :string(255)
#  code       :integer
#  created_at :datetime
#  updated_at :datetime
#

class Site < ActiveRecord::Base
  has_many :devices
  has_many :servers
  
  def storage_servers
    servers.where(role: 0)
  end
  
  def pxe_servers
    servers.where(role: 1)
  end
  
  def next_storage
    nxt = storage_servers.order(:used_at).first
    if nxt.nil?
      storage
    else
      nxt.touch(:used_at)
      nxt
    end
  end
end

# def next_server(site)
#   nxt = site.storage_servers.order(:used_at).first
#   nxt.update(used_at: Time.now)
#   nxt
# end