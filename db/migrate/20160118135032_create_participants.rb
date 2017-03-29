class CreateParticipants < ActiveRecord::Migration
  def change
    create_table :participants do |t|
      t.string :name
      t.integer :number
      t.integer :roundtrial_id, index: true

      t.timestamps null: false
    end
  end
end
