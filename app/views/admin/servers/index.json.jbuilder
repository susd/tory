json.array!(@servers) do |server|
  json.extract! server, :id, :site_id, :ip_addr, :role
  json.url server_url(server, format: :json)
end
