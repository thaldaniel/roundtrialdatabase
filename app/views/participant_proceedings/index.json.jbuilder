json.array!(@participant_proceedings) do |participant_proceeding|
  json.extract! participant_proceeding, :id, :participant_id, :proceeding_id, :device_id, :metadata
  json.url participant_proceeding_url(participant_proceeding, format: :json)
end
