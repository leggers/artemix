json.array!(@artworks) do |artwork|
  json.extract! artwork, :locked, :name
  json.url artwork_url(artwork, format: :json)
end
