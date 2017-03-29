class AddSampleNameToParticipantProceedingResults < ActiveRecord::Migration
  def change
    add_column :participant_proceeding_results, :sample_name, :string
  end
end
