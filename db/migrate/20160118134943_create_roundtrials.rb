class CreateRoundtrials < ActiveRecord::Migration
  def change
    create_table :roundtrials do |t|
      t.string :name
      t.boolean :active

      t.timestamps null: false
    end
  end
end
