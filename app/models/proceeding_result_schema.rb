class ProceedingResultSchema < ActiveRecord::Base
  belongs_to :proceeding
  serialize :result_schema
  serialize :metadata_schema
end
