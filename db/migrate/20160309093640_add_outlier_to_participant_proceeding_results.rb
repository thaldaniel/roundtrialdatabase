class AddOutlierToParticipantProceedingResults < ActiveRecord::Migration
  def change
    add_column :participant_proceeding_results, :outlier, :boolean
  end
end
