class AddDiviationsToParticipantProceedingResults < ActiveRecord::Migration
  def change
    add_column :participant_proceeding_results, :diviations, :text
  end
end
