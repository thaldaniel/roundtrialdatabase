json.array!(@participant_proceeding_results) do |participant_proceeding_result|
  json.extract! participant_proceeding_result, :id, :participant_proceeding, :results, :checked
  json.url participant_proceeding_result_url(participant_proceeding_result, format: :json)
end
