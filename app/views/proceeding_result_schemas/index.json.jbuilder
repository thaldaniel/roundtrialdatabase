json.array!(@proceeding_result_schemas) do |proceeding_result_schema|
  json.extract! proceeding_result_schema, :id, :proceeding_id, :result_schema, :metadata_schema
  json.url proceeding_result_schema_url(proceeding_result_schema, format: :json)
end
