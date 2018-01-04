json.array!(@web_contents) do |content|
  json.set! content.url, content.content
end
