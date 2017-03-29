json.array!(@proceedings) do |proceeding|
  json.extract! proceeding, :id, :roundtrial_id, :name, :last_import, :last_import
  json.url proceeding_url(proceeding, format: :json)
end
