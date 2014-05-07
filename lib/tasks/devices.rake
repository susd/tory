require 'csv'

namespace :devices do
  
  task filerename: :environment do
    path = Rails.root.join( 'public', 'uploads', 'device' )
    ['html', 'xml'].each do |type|
      Dir["#{path}/#{type}file/*"].each do |dir|
        name = File.basename(Dir["#{dir}/*"].first, ".#{type}")
        File.rename(dir, "#{path}/#{type}file/#{name}")
      end
    end
  end
  
  task relink_files: :environment do
    path = Rails.root.join('public', 'uploads', 'old_device')
    
    ['html', 'xml'].each do |type|
      count = 0
      Device.all.each do |device|
        mac = device.attributes['mac_address']
        src_path = "#{path}/#{type}file/#{mac}/#{mac}.#{type}"
        if File.exists? src_path
          src_file = File.new(src_path)
          if device.update("#{type}file" => src_file)
            count += 1
          end
        end
      end
      puts "#{type} #{count}"
    end
  end
  
  task reextract: :environment do
    Device.all.each do |device|
      device.extract_from_xml!
      device.save
    end
  end
  
end

namespace :export do
  
  desc 'Export devices'
  task devices: :environment do
    count = 0
    CSV.open('tmp/devices.csv', 'w') do |csv|
      header = Device.first.attributes.keys
      header.unshift 'site'
      csv << header
      Device.order(:id).each do |device|
        row = device.attributes.values
        row.unshift device.site.abbr
        csv << row
        count += 1
      end
    end
    puts count
  end
  
end

namespace :import do
  
  desc 'Import devices'
  task devices: :environment do
    count = 0
    CSV.foreach('tmp/devices.csv', headers: true) do |row|
      row.delete('site')
      row.delete('id')
      if Device.create(row.to_hash)
        count += 1
      end
    end
    puts count
  end
  
end