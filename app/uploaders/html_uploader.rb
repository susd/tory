# encoding: utf-8

class HtmlUploader < CarrierWave::Uploader::Base
  
  storage :file
  
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.attributes['mac_address']}"
  end
  
  def extension_white_list
    %w(htm html)
  end

end
