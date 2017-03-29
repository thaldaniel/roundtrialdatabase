json.array!(@roundtrials) do |roundtrial|
  json.extract! roundtrial, :id, :name, :active
  json.url roundtrial_url(roundtrial, format: :json)
end
