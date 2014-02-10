json.array!(@images) do |image|
  json.extract! image, :id, :name, :desc, :file
  json.url image_url(image, format: :json)
end
