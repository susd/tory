require 'csv'

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