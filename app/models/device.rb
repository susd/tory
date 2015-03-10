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
#  ram_str     :string(255)
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
#  notes       :text
#  ram         :float
#

class Device < ActiveRecord::Base
  include HardwareExtraction
  
  mount_uploader :xmlfile, XmlUploader
  mount_uploader :htmlfile, HtmlUploader
  
  store :banks, coder: JSON
  
  belongs_to :site
  belongs_to :image
  has_many :tasks, dependent: :destroy
  
  validates :mac_address, presence: true, uniqueness: true
  validates :site_id, presence: true
  
  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << ['Site','Serial','Model','CPU','Speed','RAM Total','RAM Type','Bank0','Bank1','Bank2','Bank3']
      order(:product).includes(:site).each do |device|
        row = [device.site.name]
        row += device.attributes.values_at('serial','product','cpu','cpu_speed','ram')
        row << device.fetch_banks(['0','desc'])
        4.times do |i|
          # row << device.banks[i.to_s]['size'] unless device.banks[i.to_s].nil?
          unless device.banks[i.to_s].nil?
            if device.banks[i.to_s] == "empty"
              row << "empty"
            else
              row << device.banks[i.to_s]['size']
            end
          end
        end
        csv << row
      end
    end
  end
  
  def active_task?
    !!tasks.where(state: 'active').any?
  end
  
  def product
    super || "unknown"
  end
  
  #TODO: Best name that falls back to dev-{device_id}
  
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
  
  # guards against nils
  def fetch_banks(keys = [])
    keys.inject(self.banks){|banks, key| banks && banks[key] }
  end
  
  state_machine :state, initial: :active do
    event :retire do
      transition :active => :retired
    end
    event :unretire do
      transition :retired => :active
    end
  end
  
end
