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
  mount_uploader :xmlfile, XmlUploader
  def mac_address=(str)
    self._mac_address = str.downcase.gsub(/\:/, '')
  end
  
  def mac_address
    _mac_address.scan(/\w{2}/).join(':').upcase
  end
  
  def load_xml
    @doc ||= Nokogiri::XML.parse(self.xmlfile.file.read)
  end
  
  def extract_cpu!
    load_xml
    self.cpu = @doc.css("node.processor").first.css("product").text
  end
  
  def extract_speed!
    load_xml
    mhz = @doc.css("node.processor").first.css("size").first.text.to_i / 10**6
    self._cpu_speed = mhz
  end
  
  def extract_ram!
    load_xml
    # RAM seems to be the first memory node consistently
    mem = @doc.css('node[id*=memory]').first
    bytes = mem.css('node[id*=bank] size').inject(0){|sum, s| sum + s.text.to_i}
    self.ram = "#{bytes.to_f / (2**30)} GB"
  end
  
  def extract_make!
    load_xml
    self.make = @doc.css("node.system > vendor").text
  end
  
  def extract_product!
    load_xml
    self.product = @doc.css("node.system > product").text
  end
end
