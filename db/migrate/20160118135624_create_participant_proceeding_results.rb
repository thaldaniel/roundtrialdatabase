class CreateParticipantProceedingResults < ActiveRecord::Migration
  def change
    create_table :participant_proceeding_results do |t|
      t.integer :participant_proceeding_id
      t.text :results
      t.boolean :checked

      t.timestamps null: false
    end
    add_index :participant_proceeding_results, :participant_proceeding_id, name: "part_pro_res__part_pro_id"
  end
end
