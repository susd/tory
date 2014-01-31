# == Schema Information
#
# Table name: devices
#
#  id           :integer          not null, primary key
#  site_id      :integer
#  htmlfile     :string(255)
#  xmlfile      :string(255)
#  cpu          :string(255)
#  ram          :string(255)
#  make         :string(255)
#  product      :string(255)
#  serial       :string(255)
#  uuid         :string(255)
#  ip_addr      :string(255)
#  _mac_address :string(255)
#  _cpu_speed   :integer
#  created_at   :datetime
#  updated_at   :datetime
#

class Device < ActiveRecord::Base
  
  def mac_address=(str)
    write_attribute :_mac_address, str.downcase.gsub(/\:/, '')
  end
  
  def mac_address
    _mac_address.scan(/\w{2}/).join(':').upcase
  end
end
