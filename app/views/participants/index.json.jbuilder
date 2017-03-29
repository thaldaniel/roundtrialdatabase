json.array!(@participants) do |participant|
  json.extract! participant, :id, :name, :number, :roundtrial_id
  json.url participant_url(participant, format: :json)
end
