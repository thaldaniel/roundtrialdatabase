class ParticipantProceeding < ActiveRecord::Base
  attr_accessor :participant_id, :proceeding_id, :device_id
  belongs_to :participant
  belongs_to :proceeding
  belongs_to :device
  has_many :participant_proceeding_results
  serialize :metadata
end
