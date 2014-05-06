module HardwareExtraction
  extend ActiveSupport::Concern
  
  included do
    before_create :extract_from_xml!
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
    unless self.xmlfile.nil? || self.xmlfile.file.nil?
      extract_cpu!
      extract_speed!
      extract_ram!
      extract_banks!
      extract_make!
      extract_product!
      extract_serial!
      extract_uuid!
    end
  end
  
  private
  
  def bytes_to_giga(bytes)
    bytes.to_f / (2**30)
  end
  
  def bytes_to_human(bytes)
    "#{bytes.to_f / (2**30)} GB"
  end
end