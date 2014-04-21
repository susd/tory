# == Schema Information
#
# Table name: devices
#
#  id          :integer          not null, primary key
#  site_id     :integer
#  image_id    :integer
#  htmlfile    :string(255)
#  xmlfile     :string(255)
#  cpu         :string(255)
#  ram         :string(255)
#  make        :string(255)
#  product     :string(255)
#  serial      :string(255)
#  uuid        :string(255)
#  ip_addr     :string(255)
#  mac_address :string(255)
#  cpu_speed   :integer
#  banks       :text
#  created_at  :datetime
#  updated_at  :datetime
#  state       :string(255)
#

class Device < ActiveRecord::Base
  mount_uploader :xmlfile, XmlUploader
  mount_uploader :htmlfile, HtmlUploader
  
  store :banks, coder: JSON
  
  belongs_to :site
  belongs_to :image
  has_many :tasks
  
  validates :mac_address, presence: true, uniqueness: true
  validates :site_id, presence: true
  
  before_create :extract_from_xml!
  
  concerning :MacAddressing do
    def mac_address=(str)
      super(str.downcase.gsub(/\:/, ''))
    end
  
    def mac_address
      super.scan(/\w{2}/).join(':').upcase if super
    end
  
    def pxe_mac
      "01-" << mac_address.scan(/\w{2}/).join('-').downcase
    end
  end
  
  
  
  def active_task?
    !!tasks.where(state: 'active').any?
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
    self.cpu_speed = mhz
  end
  
  def extract_ram!
    load_xml
    # RAM seems to be the first memory node consistently
    mem = @doc.css('node[id*=memory]').first
    bytes = mem.css('node[id*=bank] size').inject(0){|sum, s| sum + s.text.to_i}
    self.ram = bytes_to_giga(bytes)
  end
  
  def extract_banks!
    load_xml
    mem = @doc.css('node[id*=memory]').first # RAM seems to be the first memory node consistently
    mem.css('node[id*=bank]').each do |bank|
      pos = bank.attr('id').gsub(/\D/, '')
      bytes = bank.css('size').text.to_i
      if bytes > 0
        banks[pos] = { id: bank.attr('id'), size: bytes_to_giga(bytes) }
      else
        banks[pos] = 'empty'
      end
    end
  end
  
  def extract_make!
    load_xml
    self.make = @doc.css("node.system > vendor").text
  end
  
  def extract_product!
    load_xml
    self.product = @doc.css("node.system > product").text
  end
  
  def extract_serial!
    load_xml
    self.serial = @doc.css("node.system > serial").text
  end
  
  def extract_uuid!
    load_xml
    self.uuid = @doc.css('setting#uuid').attr('value').text
  end
  
  def extract_from_xml!
    extract_cpu!
    extract_speed!
    extract_ram!
    extract_banks!
    extract_make!
    extract_product!
    extract_serial!
    extract_uuid!
  end
  
  def best_name
    if serial && !serial.blank?
      serial
    elsif mac_address && mac_address != "00"*6
      mac_address
    else
      uuid
    end
  end
  
  def has_image?
    image_id.present?
  end
  
  state_machine :state, initial: :active do
    event :retire do
      transition :active => :retired
    end
    event :unretire do
      transition :retired => :active
    end
  end
  
  private
  
  def bytes_to_giga(bytes)
    "#{bytes.to_f / (2**30)} GB"
  end
  
end
