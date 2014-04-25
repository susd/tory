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
  include HardwareExtraction
  
  mount_uploader :xmlfile, XmlUploader
  mount_uploader :htmlfile, HtmlUploader
  
  store :banks, coder: JSON
  
  belongs_to :site
  belongs_to :image
  has_many :tasks
  
  validates :mac_address, presence: true, uniqueness: true
  validates :site_id, presence: true
  
  def active_task?
    !!tasks.where(state: 'active').any?
  end
  
  def product
    super || ""
  end
  
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
