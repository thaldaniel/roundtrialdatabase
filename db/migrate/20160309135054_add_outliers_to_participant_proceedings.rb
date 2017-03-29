class AddOutliersToParticipantProceedings < ActiveRecord::Migration
  def change
    add_column :participant_proceeding_results, :outliers, :text
  end
end
