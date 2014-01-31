json.array!(@devices) do |device|
  json.extract! device, :xmldata
  json.url device_url(device, format: :json)
end
