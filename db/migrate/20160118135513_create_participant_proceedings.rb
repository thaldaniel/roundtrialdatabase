class CreateParticipantProceedings < ActiveRecord::Migration
  def change
    create_table :participant_proceedings do |t|
      t.integer :participant_id, index: true
      t.integer :proceeding_id, index: true
      t.integer :device_id, index: true
      t.text :metadata

      t.timestamps null: false
    end
  end
end
