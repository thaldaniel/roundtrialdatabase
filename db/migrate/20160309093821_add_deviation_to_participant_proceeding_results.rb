class AddDeviationToParticipantProceedingResults < ActiveRecord::Migration
  def change
    add_column :participant_proceeding_results, :deviation, :boolean
  end
end
